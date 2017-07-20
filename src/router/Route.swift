//
//  Route.swift
//  CodeData
//
//  Created by Paul Napier on 19/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit
import Foundation

typealias User = String
typealias Key = String
typealias Value = Any
typealias Parameters = [Key:Value]

extension Sequence where Iterator.Element == URLQueryItem {
    var parameters: [Key: Value] {
        return reduce([Key:Value]()) { $0.1.value != nil ? $0.0.merge(with: [$0.1.name: $0.1.value!]) : $0.0 }
    }
}

extension Dictionary {
    func merge(with: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var copy = self
        for (k, v) in with {
            copy[k] = v
        }
        return copy
    }
    
    mutating func append(with: Dictionary<Key,Value>) {
        for (k, v) in with {
            self[k] = v
        }
    }
}

protocol URLInitialisable {
    init?(string: String)
    init?(url: URL)
    init?(components: URLComponents)
}

extension URLInitialisable {
    init?(string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }
    
    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        self.init(components: components)
    }
}

enum Route {
    case home
    case profile(user: User)
    
    init?(components: URLComponents) {
        let path = Path(string: components.path)
        
        switch path.components.count {
        case 1:
            guard case let first = path.components[0], first == "home" else { return nil }
            self = .home
        case 2:
            guard case let first = path.components[0], first == "profile" else { return nil }
            let second = path.components[1]
            self = .profile(user: second)
            
        default: return nil
        }
        
    }
}

extension Route: URLInitialisable {}

extension Route {
    var view: ControlledView {
        switch self {
        case .home: return HomeView()
        case .profile: return ProfileView()
        }
    }
}

extension Route {
    var parameters: [Key : Value] {
        switch self {
        case .home: return ["endpoint":"users"]
        case .profile(user: let user): return ["title": user, "endpoint": "\(user)/repos", "relationship" : "login", "id" : user]
        }
    }
}
