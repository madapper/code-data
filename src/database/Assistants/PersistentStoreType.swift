//
//  PersistentStoreType.swift
//  CodeData
//
//  Created by Paul Napier on 20/7/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import CoreData

enum PersistentStoreType {
    case sqlite
    case binary
    case inMemory
    
    public static let defaultStoreName = "database"
    public static let defaultExtensionName = ".sqlite"
    
    public var description:String {
        switch self {
        case .sqlite: return NSSQLiteStoreType
        case .binary: return NSBinaryStoreType
        case .inMemory: return NSInMemoryStoreType
        }
    }
    
    public var extensionName:String {
        switch self {
        case .sqlite: return PersistentStoreType.defaultExtensionName
        case .binary: return ".db"
        case .inMemory: return ""
        }
    }
}
