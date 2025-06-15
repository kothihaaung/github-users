//
//  GetUserDetailUseCase.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/15.
//

import Foundation
import Combine

public protocol GetUserDetailCaseConvertible: Sendable {
    func execute(login: String) async throws -> UserDetail
}

public final class GetUserDetailUseCase: GetUserDetailCaseConvertible, @unchecked Sendable {
    private let repo: GitHubRepoConvertible
    private var subscriptions = Set<AnyCancellable>()
    
    public init(repo: GitHubRepoConvertible) {
        self.repo = repo
    }
    
    private func execute(login: String, completionHandler: @escaping (Result<UserDetail, Error>) -> Void) {
        repo
            .getUserDetail(login: login)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    completionHandler(.failure(error))
                }
            } receiveValue: { userDetail in
                completionHandler(.success(userDetail))
            }
            .store(in: &subscriptions)
    }
    
    public func execute(login: String) async throws -> UserDetail {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.execute(login: login, completionHandler: { result in
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
