//
//  Test.swift
//  CodeData
//
//  Created by Paul Napier on 22/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import CoreData

@objc(Users)
class Users: NSManagedObject {}

extension Users {
    @NSManaged var id: Int
    @NSManaged var title:String
    @NSManaged var image: String
    @NSManaged var url: String
//    @NSManaged var site_admin: Bool 
    @NSManaged var repos: String
}

extension Users: Entity {}

extension Users: EntityDatasource {
    static var variableRouting:[String:String] {
        return [
            "repos":"/repos_url",
            "title":"/login",
            "image":"/avatar_url",
        ]
    }
}

/*=======================================*/

@objc(Repos)
class Repos: NSManagedObject {}

extension Repos {
    @NSManaged var id: Int
    @NSManaged var title:String
    @NSManaged var login: String
    @NSManaged var owner: Int
    @NSManaged var url: String
}

extension Repos: Entity {}

extension Repos: EntityDatasource {
    static var variableRouting:[String:String] {
        return [
            "owner":"/owner/id",
            "login":"/owner/login",
            "title":"/name",
        ]
    }
}
