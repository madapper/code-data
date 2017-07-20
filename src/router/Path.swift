//
//  Path.swift
//  CodeData
//
//  Created by Paul Napier on 19/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import Foundation

struct Path {
    let components: [String]
    init(string: String, delimiter: URLSeparator = .path) {
        components = string.components(separatedBy: delimiter.value)
    }
    
    var string: String {
        return components.joined(with: .path)
    }
    
    var url: URL? {
        return URL(string: string)
    }
}

extension Path: Hashable {
    var hashValue: Int {
        return components.joined(with: .path).hashValue
    }
}

func == (lhs: Path, rhs: Path) -> Bool {
    return lhs.components == rhs.components
}
