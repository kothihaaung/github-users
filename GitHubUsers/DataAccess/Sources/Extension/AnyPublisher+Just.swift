//
//  AnyPublisher+Just.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Combine

extension AnyPublisher {
    static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    static func fail(with error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }
}
