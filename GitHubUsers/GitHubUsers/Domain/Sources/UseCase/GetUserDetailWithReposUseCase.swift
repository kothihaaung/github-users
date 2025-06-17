//
//  GetUserDetailWithReposUseCase.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/16.
//

import Foundation
import Combine

public protocol GetUserDetailWithReposUseCaseConvertible: Sendable {
    func execute(login: String, perPage: Int, page: Int) async throws -> (UserDetail, [Repo], Int?)
}

public final class GetUserDetailWithReposUseCase: GetUserDetailWithReposUseCaseConvertible, @unchecked Sendable {
    private let repo: GitHubRepoConvertible
    private var subscriptions = Set<AnyCancellable>()
    
    public init(repo: GitHubRepoConvertible) {
        self.repo = repo
    }
    
    private func execute(login: String, perPage: Int, page: Int, completionHandler: @escaping (Result<(UserDetail, [Repo], Int?), Error>) -> Void) {
        let userDetailPublisher = repo.getUserDetail(login: login)
        let userReposPublisher = repo
            .getUserRepos(login: login, perPage: perPage, page: page)
            .map { result in
                let repos = result.repos.filter { !$0.fork } // filtered out forked repos
                return (repos: repos, nextPage: result.nextPage)
            }
            .eraseToAnyPublisher()
        
        Publishers.Zip(userDetailPublisher, userReposPublisher)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    completionHandler(.failure(error))
                }
            } receiveValue: { userDetail, repoResult in
                completionHandler(.success((userDetail, repoResult.repos, repoResult.nextPage)))
            }
            .store(in: &subscriptions)
    }
    
    public func execute(login: String, perPage: Int, page: Int) async throws -> (UserDetail, [Repo], Int?) {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.execute(login: login, perPage: perPage, page: page, completionHandler: { result in
                switch result {
                case .success(let userDetailWithRepos):
                    continuation.resume(returning: userDetailWithRepos)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        }
    }
}
