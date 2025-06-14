//
//  GetUsersUseCase.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Foundation
import Combine

public protocol GetUsersUseCaseConvertible: Sendable {
    func execute() async throws -> [User]
}

public final class GetUsersUseCase: GetUsersUseCaseConvertible, @unchecked Sendable {
    private let repo: GitHubRepoConvertible
    private var subscriptions = Set<AnyCancellable>()
    
    public init(repo: GitHubRepoConvertible) {
        self.repo = repo
    }
    
    private func execute(completionHandler: @escaping (Result<[User], Error>) -> Void) {
        repo
            .users
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    completionHandler(.failure(error))
                }
            } receiveValue: { currencyList in
                completionHandler(.success(currencyList))
            }
            .store(in: &subscriptions)
    }
    
    public func execute() async throws -> [User] {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.execute(completionHandler: { result in
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
