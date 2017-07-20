//
//  ControlledView.swift
//  CodeData
//
//  Created by Paul Napier on 25/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import UIKit

class ControlledView: View {
    
    lazy var layoutConstraints: [NSLayoutConstraint] = { [unowned self] in
       return [
        NSLayoutConstraint(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        ]
    }()
    
    lazy var tableView: TableView = { [unowned self] in
        $0.translatesAutoresizingMaskIntoConstraints = false
       return $0
    }(TableView())
    
    override init() {
        super.init()
        addSubview(tableView)
        addConstraints(layoutConstraints)
        setNeedsUpdateConstraints()
        tableView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ControlledView {
    func navigate(to: Endpoint) {
        to.path.components.joined(with: .path).performRoute()
    }
}

extension ControlledView: UITableViewDelegate {
    
}
