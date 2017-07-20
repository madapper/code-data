//
//  MAObject+Generic.swift
//  iPagination
//
//  Created by Paul Napier on 25/02/2016.
//  Copyright © 2016 Paul Napier. All rights reserved.
//

import Foundation

extension NSObject {
    
    //
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    //
    
    static var propertyList: [String:String] {
        var results: [String:String] = [:]
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0
        let myClass: AnyClass = self.classForCoder()
        let properties = class_copyPropertyList(myClass, &count)
        
        // iterate each objc_property_t struct
        for i in 0..<count {
            let property = properties?[Int(i)]
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property)
            let cattribute = property_getAttributes(property)
            
            // covert the c string into a Swift string
            let name = String(cString: cname!)
            let attributes = String(cString: cattribute!).components(separatedBy: ",")
            if let attribute = attributes.first {
                results.updateValue(attribute, forKey: name)
            }
            
        }
        
        // release objc_property_t structs
        free(properties)
        
        return results
    }
    
    public static func subclasses(conforming toProtocol:Protocol) -> [AnyClass] {
        
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
        let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)], class_getSuperclass(allClasses[Int(i)]) == classForKeyedArchiver() && class_conformsToProtocol(currentClass, toProtocol) {
                classes.append(currentClass)
            }
        }
        
        allClasses.deallocate(capacity: Int(expectedClassCount))
        
        return classes
    }
    
}
