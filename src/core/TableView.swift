//
//  TableView.swift
//  CodeData
//
//  Created by Paul Napier on 25/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit

class TableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
