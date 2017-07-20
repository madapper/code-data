//
//  Routing.swift
//  CodeData
//
//  Created by Paul Napier on 19/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import Foundation

protocol Routing {
    func performRoute()
}

extension Router: Routing {
    func performRoute() {
        route(with: self)
    }
}

extension String: Routing {
    func performRoute() {
        Router(string: self)?.performRoute()
    }
}

extension URL: Routing {
    func performRoute() {
        Router(url: self)?.performRoute()
    }
}

extension URLComponents: Routing {
    func performRoute() {
        Router(components: self)?.performRoute()
    }
}
