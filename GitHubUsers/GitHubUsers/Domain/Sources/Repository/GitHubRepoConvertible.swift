//
//  GitHubRepoConvertible.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Foundation
import Combine

public protocol GitHubRepoConvertible {
    var users: AnyPublisher<[User], Error> { get }
}
