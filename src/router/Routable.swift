//
//  Routable.swift
//  CodeData
//
//  Created by Paul Napier on 19/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//


import Foundation

protocol Routable {
    func route(with: Router)
}

extension Routable {
    func route(with router: Router) {
        AppDelegate.window?.navigator.pushViewController(router.controller, animated: true)
    }
}
