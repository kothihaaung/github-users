//
//  Network.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Combine
import Foundation
import Alamofire

public protocol NetworkConvertible {
    func run<T: Decodable>(_ api: DataAPI) -> AnyPublisher<Response<T>, Error>
}

public struct Network: NetworkConvertible {
    private let decoder = JSONDecoder()
    
    public init() {}
    
    public func run<T: Decodable>(_ api: DataAPI) -> AnyPublisher<Response<T>, Error> {
        guard let url = URL(string: api.urlString) else {
            return .fail(with: NetworkError.failedToMakeURL(api.urlString))
        }
        
        return AF
            .request(url,
                     method: api.method,
                     parameters: api.params,
                     encoding: api.encoding,
                     headers: api.headers)
            .validate(statusCode: 200..<300)
            .publishResponse(using: DataResponseSerializer())
            .tryMap { result -> Response<T> in
                guard
                    let data = result.data,
                    let response = result.response
                else {
                    throw NetworkError.noResponseData
                }
                
                let value = try decoder.decode(T.self, from: data)
                return Response(value: value, response: response)
            }
            .eraseToAnyPublisher()

    }
}

public struct Response<T> {
    let value: T
    let response: HTTPURLResponse
}
