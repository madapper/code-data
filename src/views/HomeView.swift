//
//  HomeView.swift
//  CodeData
//
//  Created by Paul Napier on 18/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit
import CoreData

class HomeView: ControlledView {}

extension HomeView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let datasource = tableView.dataSource as? Controller else { return }
        guard let data = datasource.fetchedResultsController?.sections?[indexPath.section].objects?[indexPath.row] as? NSManagedObject else { return }
        guard let title = data["title"] as? String else { return }
        Router(route: .profile(user: title)).performRoute()
    }
}
