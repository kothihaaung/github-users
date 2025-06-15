//
//  GitHubAPI.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Alamofire

enum GitHubAPI: DataAPI {
    case users(since: Int, perPage: Int)
    case userDetail(login: String)
    case repos(login: String, perPage: Int)
    
    private var baseURL: String { "api.github.com" }
    
    var urlString: String {
        switch self {
        case .users:
            "https://\(baseURL)/users"
            
        case .userDetail(let login):
            "https://\(baseURL)/users/\(login)"
            
        case .repos(let login, _):
            "https://\(baseURL)/users/\(login)/repos"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [
            "Authorization": "",
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
    }
    
    var params: [String: any Sendable]? {
        switch self {
        case .users(let since, let perPage):
            var query: [String: any Sendable] = [:]
            query["since"] = since
            query["per_page"] = perPage
            return query
            
        case .repos(_, let perPage):
            var query: [String: any Sendable] = [:]
            query["per_page"] = perPage
            return query
            
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
}
