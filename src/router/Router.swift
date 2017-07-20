//
//  Router.swift
//  CodeData
//
//  Created by Paul Napier on 19/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import Foundation

struct Router {
    let route: Route
    let parameters: Parameters
    
    init?(components: URLComponents) {
        guard let route = Route(components: components) else { return nil }
        self.init(route: route)
    }
    
    init(route: Route) {
        self.route = route
        self.parameters = route.parameters
    }
}

extension Router: URLInitialisable {}

extension Router {
    var controller: Controller {
        return Controller(view: route.view, parameters: parameters)
    }
}

extension Router: Routable {}
