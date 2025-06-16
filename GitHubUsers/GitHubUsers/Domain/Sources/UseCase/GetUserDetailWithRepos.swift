//
//  GetUserDetailWithRepos.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/16.
//

import Foundation
import Combine

public protocol GetUserDetailWithReposUseCaseConvertible: Sendable {
    func execute(login: String, perPage: Int) async throws -> (UserDetail, [Repo])
}

public final class GetUserDetailWithReposUseCase: GetUserDetailWithReposUseCaseConvertible, @unchecked Sendable {
    private let repo: GitHubRepoConvertible
    private var subscriptions = Set<AnyCancellable>()
    
    public init(repo: GitHubRepoConvertible) {
        self.repo = repo
    }
    
    private func execute(login: String, perPage: Int, completionHandler: @escaping (Result<(UserDetail, [Repo]), Error>) -> Void) {
        let userDetailPublisher = repo.getUserDetail(login: login)
        let userReposPublisher = repo.getUserRepos(login: login, perPage: perPage)

        Publishers.Zip(userDetailPublisher, userReposPublisher)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    completionHandler(.failure(error))
                }
            } receiveValue: { userDetail, repos in
                completionHandler(.success((userDetail, repos)))
            }
            .store(in: &subscriptions)
    }

    
    public func execute(login: String, perPage: Int) async throws -> (UserDetail, [Repo]) {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.execute(login: login, perPage: perPage, completionHandler: { result in
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
