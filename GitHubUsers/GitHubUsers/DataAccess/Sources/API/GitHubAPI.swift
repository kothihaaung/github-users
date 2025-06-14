//
//  GitHubAPI.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Alamofire

enum GitHubAPI: DataAPI {
    case users
    case repos(String)
    
    private var baseURL: String { "api.github.com" }
    
    var urlString: String {
        switch self {
        case .users:
            "https://\(baseURL)/users"
            
        case .repos(let user):
            "https://\(baseURL)/users/\(user)/repos"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var params: [String : any Sendable]? {
        [
            "Authorization": "",
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
}
