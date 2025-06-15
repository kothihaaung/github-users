//
//  GitHubRepoConvertible.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Foundation
import Combine

public protocol GitHubRepoConvertible: Sendable {
    func getUsers(since: Int, perPage: Int) -> AnyPublisher<(users: [User], nextSince: Int?), Error>
    func getUserDetail(login: String) -> AnyPublisher<UserDetail, Error>
}
