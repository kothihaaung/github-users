//
//  GitHubRepo.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Domain
import Combine

public class GitHubRepo: GitHubRepoConvertible {
    @MainActor public static let shared = GitHubRepo()
    
    private let network: NetworkConvertible
    
    public init(network: NetworkConvertible = Network()) {
        self.network = network
    }
    
    public var users: AnyPublisher<[User], Error> {
        let api: GitHubAPI = .users
        return network
            .run(api)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
