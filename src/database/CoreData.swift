//
//  CoreData.swift
//  CodeData
//
//  Created by Paul Napier on 22/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import CoreData

typealias JSONObject = [Key : Value]
typealias JSONArray = [JSONObject]
typealias Parent = (object: NSManagedObject, key: String)

class CoreData {
    static let shared = CoreData()
    private let options: [String: AnyObject] = [
        NSMigratePersistentStoresAutomaticallyOption: true as AnyObject,
        NSInferMappingModelAutomaticallyOption: true as AnyObject,
        ]
    private let storeType: PersistentStoreType = .sqlite
    private var storeName:String {
        return Bundle(for: CoreData.self).bundleIdentifier ?? PersistentStoreType.defaultStoreName
    }
    
    fileprivate lazy var model: NSManagedObjectModel = { [unowned self] in
        $0.entities.append(contentsOf: NSManagedObjectModel.derivedEntities.map{NSEntityDescription.generate(entity: $0.key, ofType: $0.value)})
        return $0
        }(NSManagedObjectModel())
    
    fileprivate lazy var coordinator: NSPersistentStoreCoordinator = { [unowned self] in
        return self.model.coordinator.update {
            $0.persistantStore(ofType: self.storeType, options: self.options, url: URL.applicationDocumentsDirectory.appendingPathComponent(self.storeName + self.storeType.extensionName))
        }
    }()
    
    // MARK: Managed Object Contexts
    
    fileprivate lazy var writerContext: NSManagedObjectContext? = { [unowned self] in
        return self.coordinator.context()
    }()
    
    lazy var context: NSManagedObjectContext? = { [unowned self] in
        return self.coordinator.context(withParent: self.writerContext, concurrencyType: .mainQueueConcurrencyType)
    }()
    
}

extension NSManagedObjectModel {
    static let derivedEntities: [String:NSManagedObject.Type] =
        NSManagedObject.subclasses(conforming: Entity.self)
            .flatMap{$0 as? NSManagedObject.Type}
            .filter{$0 is EntityDatasource.Type}
            .reduce([:], { (result, next) -> [String:NSManagedObject.Type] in
                    var output = result
                    output[next.entityName] = next
                    return output
            })
    
    var coordinator: NSPersistentStoreCoordinator {
        return NSPersistentStoreCoordinator(managedObjectModel: self)
    }
}

extension NSEntityDescription {
    static func generate(entity name: String,
                         ofType type: NSManagedObject.Type) -> NSEntityDescription {
        return NSEntityDescription().update {
            $0.name = name
            $0.managedObjectClassName = name
            $0.properties = type.attributes
        }
    }
}

extension NSManagedObject {
    static var attributes: [NSAttributeDescription] {
        return propertyList.flatMap { (key, value) -> NSAttributeDescription? in
            guard let type = PropertyType(rawValue: value) else { return nil }
            return NSAttributeDescription().update {
                $0.name = key
                $0.attributeType = type.attributeType
                
                $0.isOptional = true
                $0.isIndexed = false
                $0.isTransient = false
                $0.allowsExternalBinaryDataStorage = true
            }
        }
    }
}

extension NSEntityDescription {
    func select(id: Any) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.fetchLimit = 1
        request.entity = self
        request.predicate = NSPredicate(format: "id = \(id)")
        return request
    }
}

extension NSManagedObjectContext {
    func saveChanges() {
        if hasChanges {
            performAndWait { [weak self] in
                try? self?.save()
                self?.parent?.saveChanges()
            }
        }
    }
    
    func entity(forType type: EntityDatasource.Type) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: type.entityName, in: self)
    }
    
    @discardableResult
    func create(items: JSONArray, ofType type: EntityDatasource.Type, withParent parent: Parent? = nil) -> [NSManagedObject] {
        guard let entity = entity(forType: type) else { return [] }
        let output = items.flatMap { (item) -> NSManagedObject? in
            let object: NSManagedObject?
            if let id = item["id"], let selected = select(id: id, ofType: type) {
                object = selected
            }else if let clz = NSManagedObjectModel.derivedEntities[type.entityName] {
                object = clz.init(entity: entity, insertInto: self)
            }else {
                object = nil
            }
            
            if let i = object as? EntityDatasource {
                i.populate(item)
                if let parent = parent, !parent.key.isEmpty {
                    object?.setValue(parent.object, forKey: parent.key)
                }
            }
            
            return object
        }
        
        saveChanges()
        
        return output
    }
    
    func select(id: Any, ofType type: EntityDatasource.Type) -> NSManagedObject? {
        let description = entity(forType: type)
        guard let request = description?.select(id: id) else { return nil }
        let results = try? fetch(request)
        return results?.last as? NSManagedObject
    }
    
    func delete(id: Any, ofType type: EntityDatasource.Type) {
        guard let item = select(id: id, ofType: type) else { return }
        delete(item)
        saveChanges()
    }
}

extension URL {
    public static var applicationDocumentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last ?? URL(fileURLWithPath: "")
    }
}

extension NSPersistentStoreCoordinator {
    func context(withParent parent: NSManagedObjectContext? = nil,
                 concurrencyType: NSManagedObjectContextConcurrencyType = .privateQueueConcurrencyType)
        -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: concurrencyType)
        if let parent = parent {
            context.parent = parent
        }else {
            context.persistentStoreCoordinator = self
        }
        return context
    }
    
    @discardableResult
    func persistantStore(ofType type: PersistentStoreType,
                         options:[String:AnyObject], url:URL)
        -> NSPersistentStore? {
            print(url)
        return try? addPersistentStore(ofType: type.description,
                                       configurationName: nil,
                                       at: url,
                                       options: options)
    }
}
