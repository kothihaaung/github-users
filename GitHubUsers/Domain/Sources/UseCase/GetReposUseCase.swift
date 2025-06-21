//
//  GetReposUseCase.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/21.
//

import Combine
import Foundation

public protocol GetReposUseCaseConvertible: Sendable {
    func execute(login: String, perPage: Int, page: Int) async throws -> (repos: [Repo], nextPage: Int?)
}

public final class GetReposUseCase: GetReposUseCaseConvertible, @unchecked Sendable {
    private let repo: GitHubRepoConvertible
    private var subscriptions = Set<AnyCancellable>()
    
    public init(repo: GitHubRepoConvertible) {
        self.repo = repo
    }
    
    private func execute(login: String, perPage: Int, page: Int, completionHandler: @escaping (Result<([Repo], Int?), Error>) -> Void) {
        repo
            .getUserRepos(login: login, perPage: perPage, page: page)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    completionHandler(.failure(error))
                }
            } receiveValue: { result in
                completionHandler(.success(result))
            }
            .store(in: &subscriptions)
    }
    
    public func execute(login: String, perPage: Int, page: Int) async throws -> (repos: [Repo], nextPage: Int?) {
        try await asyncFromCompletion { completion in
            self.execute(login: login, perPage: perPage, page: page, completionHandler: completion)
        }
    }
}
