//
//  Controller.swift
//  CodeData
//
//  Created by Paul Napier on 18/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit
import CoreData

class Controller: UIViewController {
    let parameters: Parameters
    
    fileprivate lazy var request: NSFetchRequest<NSFetchRequestResult>? = {
        guard let value = self.parameters["endpoint"] as? String else { return nil }
        guard let endpoint = Endpoint(string: value) else { return nil }
        let request = endpoint.entity.request
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        if let relationship = self.parameters["relationship"] as? CVarArg,
            let id = self.parameters["id"] as? CVarArg {
            request.predicate = NSPredicate(format: "\(relationship)=%@", id)
        }
        return request
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = { [unowned self] in
        guard let context = CoreData.shared.context else { return nil }
        guard let request = self.request else { return nil }
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    init(view: ControlledView = ControlledView(), parameters: Parameters) {
        self.parameters = parameters
        super.init(nibName: nil, bundle: nil)
        self.view = view
        self.title = parameters["title"] as? String
        view.tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? fetchedResultsController?.performFetch()
        guard let value = parameters["endpoint"] as? String else { return }
        guard let endpoint = Endpoint(string: value) else { return }
        API(endpoint: endpoint).connect()
    }
}

extension String {
    var imagify: (Cell?) -> Void {
        return {(input) -> Void in
            guard let cell = input else { return }
            cell.imageView?.image = nil
            guard let url = URL(string: self) else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { return }
                DispatchQueue.main.async(execute: {
                    let image = UIImage(data: data)
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                })
            })
            task.resume()
        }
    }
}

extension NSManagedObject {
    subscript (key: String) -> Any? {
        guard entity.propertiesByName.keys.contains(key) else { return nil }
        return value(forKey: key)
    }
}

extension Controller: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        (view as? ControlledView)?.tableView.reloadData()
    }
}

extension Controller: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.entityName) as? Cell ?? Cell(indexPath: indexPath)
        if let data = fetchedResultsController?.sections?[indexPath.section].objects?[indexPath.row] as? NSManagedObject {
            if let title = data["title"] {
                cell.textLabel?.text = String(describing: title)
            }
            if let image = data["image"] as? String {
                image.imagify(cell)
            }
            if let isSiteAdmin = data["site_admin"] as? Bool {
                cell.backgroundColor = isSiteAdmin ? .green : .red
            }
        }
        return cell
    }
}
