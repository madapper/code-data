//
//  File.swift
//  iPagination
//
//  Created by Paul Napier on 25/02/2016.
//  Copyright © 2016 Paul Napier. All rights reserved.
//

import CoreData

public enum PropertyType:String {
    
    case String = "T@\"NSString\""
    case Bool = "TB"
    case Int = "Tq"
    case Int16 = "Ts"
    case Int32 = "Ti"
    case Double = "Td"
    case Float = "Tf"
    
    var attributeType:NSAttributeType {
        switch self {
        case .String: return .stringAttributeType
        case .Bool: return .booleanAttributeType
        case .Int: return .integer64AttributeType
        case .Int16: return .integer16AttributeType
        case .Int32: return .integer32AttributeType
        case .Float: return .floatAttributeType
        case .Double: return .doubleAttributeType
        }
    } 
}
