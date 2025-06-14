//
//  GitHubRepoConvertible.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Foundation
import Combine

public protocol GitHubRepoConvertible {
    func getUsers(since: Int, perPage: Int) -> AnyPublisher<(users: [User], nextSince: Int?), Error>
}
