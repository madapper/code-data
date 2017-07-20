//
//  Window.swift
//  CodeData
//
//  Created by Paul Napier on 18/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit

class Window: UIWindow {
    let navigator: Navigator
    init?(navigator: Navigator? = Navigator()) {
        guard let navigator = navigator else { return nil }
        self.navigator = navigator
        super.init(frame: UIScreen.main.bounds)
        rootViewController = navigator
        makeKeyAndVisible()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
