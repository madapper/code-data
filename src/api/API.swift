//
//  API.swift
//  CodeData
//
//  Created by Paul Napier on 24/5/17.
//  Copyright © 2017 MadApper. All rights reserved.
//

import Foundation

enum URLSeparator {
    case scheme
    case host
    case path
    
    var value: String {
        switch self {
        case .scheme: return "://"
        case .host: return "."
        case .path: return "/"
        }
    }
}

enum Endpoint {
    case users
    case repos(user: String)
    
    init?(string: String) {
        self.init(path: Path(string: string))
    }
    
    init?(path: Path) {
        switch path {
        case Endpoint.users.path: self = .users
        default:
            switch path.components.last {
            case .some(let value):
                switch value {
                case "repos" where path.components.count == 2: self = .repos(user: path.components[0])
                default: return nil
                }
            default: return nil
            }
        }
    }
    
    var path: Path {
        switch self {
        case .users: return Path(string: "users")
        case .repos(user: let user): return Path(string: "users/\(user)/repos")
        }
    }
    
    var entity: EntityDatasource.Type {
        switch self {
        case .users: return Users.self
        case .repos: return Repos.self
        }
    }
    
    var route: Route {
        switch self {
        case .users: return .home
        case .repos(user: let user): return .profile(user: user)
        }
    }
}

extension Array where Element == String {
    func joined(with separator: URLSeparator) -> String {
        return joined(separator: separator.value)
    }
}

struct API {
    private static let session = URLSession(configuration: .default)
    private static let map: [Path:EntityDatasource.Type] = [Path(string: "users"):Users.self]
    private let scheme = "https"
    private let host = ["api", "github", "com"]
    let endpoint: Endpoint
    
    var absoluteString: String {
        return scheme + URLSeparator.scheme.value + host.joined(with: .host) + URLSeparator.path.value + endpoint.path.components.joined(with: .path)
    }
    
    var url: URL? {
        return URL(string: absoluteString)
    }
    
    var task: URLSessionTask? {
        guard let url = url else { return nil }
        return API.session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard let body = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
            guard let results = body as? JSONArray else { return }
            CoreData.shared.context?.create(items: results, ofType: self.endpoint.entity)
        }
    }
}

extension API {
    func connect() {
        task?.resume()
    }
}
