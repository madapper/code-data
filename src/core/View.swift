//
//  View.swift
//  CodeData
//
//  Created by Paul Napier on 18/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit

class View: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
