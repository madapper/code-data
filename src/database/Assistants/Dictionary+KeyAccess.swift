//
//  Dictionary+KeyAccess.swift
//  iPagination
//
//  Created by Paul Napier on 23/02/2016.
//  Copyright © 2016 Paul Napier. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func toBool(_ key:String, defaultValue:Bool = false) -> Bool {
        
        if let k = key as? Key, let value = self[k] as? Bool {
            return value
        }
        
        return defaultValue
    }
    
    func toString(_ key:String, defaultValue:String = "") -> String {
        if let k = key as? Key, let value = self[k] as? String {
            return value
        }
        
        return defaultValue
    }
    
    func toInt(_ key:String, defaultValue:Int = 0) -> Int {
        if let k = key as? Key, let value = self[k] as? Int {
            return value
        }
        
        return defaultValue
    }
    
    func toFloat(_ key:String, defaultValue:Float = 0) -> Float {
        if let k = key as? Key, let value = self[k] as? Float {
            return value
        }
        
        return defaultValue
    }
    
    func toDouble(_ key:String, defaultValue:Double = 0) -> Double {
        if let k = key as? Key, let value = self[k] as? Double {
            return value
        }
        
        return defaultValue
    }
    
    func toDict(_ key:String, defaultValue: JSONObject = [:]) -> JSONObject {
        if let k = key as? Key, let value = self[k] as? JSONObject {
            return value
        }
        
        return defaultValue
    }
    
    func toArray(_ key:String, defaultValue:[AnyObject] = []) -> [AnyObject] {
        if let k = key as? Key, let value = self[k] as? [AnyObject] {
            return value
        }
        
        return defaultValue
    }
    
}
