//
//  MAEntityDatasource.swift
//  iPagination
//
//  Created by Paul Napier on 18/05/2016.
//  Copyright © 2016 Paul Napier. All rights reserved.
//

import CoreData

protocol EntityDatasource {
    static var entityName:String { get }
    static var variableRouting:[String:String] { get }
    func populate(_ dictionary: JSONObject)
    static func setAttributeProperties()
    static var request: NSFetchRequest<NSFetchRequestResult> { get }
}

extension EntityDatasource {
    static var variableRouting:[String:String] { return [:] }
    static func setAttributeProperties() {}
}

extension EntityDatasource where Self: NSManagedObject {
    static var request: NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: Self.entityName)
    }
    
    static func select(id: Any) -> NSFetchRequest<Self> {
        let request = Self.request.copy() as! NSFetchRequest<Self>
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = \(id)")
        return request
    }
}

extension EntityDatasource where Self: NSObject, Self: Entity {
    
    func populate(_ dictionary: JSONObject) {
        
        let items = Self.propertyList
        
        for item in items {
            if let propertyType = PropertyType(rawValue: item.1) {
                
                if let map = Self.self.variableRouting[item.0] {
                    
                    var dict = dictionary.toDict(item.0)
                    
                    if dict.isEmpty {
                        dict = dictionary
                    }
                    
                    let paths = map.components(separatedBy: "/")
                    
                    for (index, path) in paths.enumerated() where index > 0 {
                        if index == paths.count - 1 {
                            setValue(dict, key: path, keyAlias: item.0, propertyType: propertyType)
                        }else {
                            dict = dict.toDict(path)
                        }
                    }
                    
                }else {
                    setValue(dictionary, key: item.0, propertyType: propertyType)
                }
            }
        }
    }
    
    func setValue(_ dict: JSONObject, key:String, keyAlias:String = "", propertyType:PropertyType) {
        
        let current: Any? = value(forKey: keyAlias.isEmpty ? key : keyAlias)
        let replacing: Any
        let shouldReplace: Bool
        
        switch propertyType {
        case .String:
            let toReplace = dict.toString(key)
            if let existing = current as? String, existing == toReplace {
                shouldReplace = false
            }else {
                shouldReplace = true
            }
            replacing = toReplace
        case .Bool:
            let toReplace = dict.toBool(key)
            if let existing = current as? Bool, existing == toReplace {
                shouldReplace = false
            }else {
                shouldReplace = true
            }
            replacing = toReplace
        case .Int:
            let toReplace = dict.toInt(key)
            if let existing = current as? Int, existing == toReplace {
                shouldReplace = false
            }else {
                shouldReplace = true
            }
            replacing = toReplace
        case .Int16:
            let toReplace = dict.toInt(key)
            if let existing = current as? Int, existing == toReplace {
                shouldReplace = false
            }else {
                shouldReplace = true
            }
            replacing = toReplace
        case .Int32:
            let toReplace = dict.toInt(key)
            if let existing = current as? Int, existing == toReplace {
                shouldReplace = false
            }else {
                shouldReplace = true
            }
            replacing = toReplace
        case .Float:
            let toReplace = dict.toFloat(key)
            if let existing = current as? Float, existing == toReplace {
                shouldReplace = false
            }else {
                shouldReplace = true
            }
            replacing = toReplace
        case .Double:
            let toReplace = dict.toDouble(key)
            if let existing = current as? Double, existing == toReplace {
                shouldReplace = false
            }else {
                shouldReplace = true
            }
            replacing = toReplace
        }
        
        if shouldReplace {
            setValue(replacing, forKey: keyAlias.isEmpty ? key : keyAlias)
        }
        
    }
}

extension NSObject {
    static var entityName: String {
        return description().components(separatedBy: ".").last ?? ""
    }
}
