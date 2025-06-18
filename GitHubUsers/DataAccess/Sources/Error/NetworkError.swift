//
//  NetworkError.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

enum NetworkError: Error {
    case failedToMakeURL(String)
    case noResponseData
}
