//
//  GetUsersUseCase.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Foundation
import Combine

public protocol GetUsersUseCaseConvertible: Sendable {
    func execute(since: Int, perPage: Int) async throws -> (users: [User], nextSince: Int?)
}

public final class GetUsersUseCase: GetUsersUseCaseConvertible, @unchecked Sendable {
    private let repo: GitHubRepoConvertible
    private var subscriptions = Set<AnyCancellable>()
    
    public init(repo: GitHubRepoConvertible) {
        self.repo = repo
    }
    
    private func execute(since: Int, perPage: Int, completionHandler: @escaping (Result<(users: [User], nextSince: Int?), Error>) -> Void) {
        repo
            .getUsers(since: since, perPage: perPage)
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
    
    public func execute(since: Int, perPage: Int) async throws -> (users: [User], nextSince: Int?) {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.execute(since: since, perPage: perPage, completionHandler: { result in
                switch result {
                case .success(let users):
                    continuation.resume(returning: users)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        }
    }
}
