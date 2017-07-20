//
//  Cell.swift
//  CodeData
//
//  Created by Paul Napier on 25/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    let indexPath: IndexPath
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(style: .default, reuseIdentifier: Cell.entityName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
