//
//  AsyncHelpers.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/21.
//

import Foundation

func asyncFromCompletion<T: Sendable>(
    _ operation: (@escaping (Result<T, Error>) -> Void) -> Void
) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
        operation { result in
            switch result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}
