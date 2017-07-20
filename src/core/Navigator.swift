//
//  Navigation.swift
//  CodeData
//
//  Created by Paul Napier on 18/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit

class Navigator: UINavigationController {
    init?(router: Router? = Router(string: "home?title=Home")) {
        guard let router = router else { return nil }
        super.init(rootViewController: router.controller)
        view.backgroundColor = .white
        navigationBar.isTranslucent = false
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
