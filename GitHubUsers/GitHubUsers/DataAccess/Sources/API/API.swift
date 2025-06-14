//
//  API.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Alamofire

public protocol API {
    var urlString: String { get }
    var method: HTTPMethod { get }
}

public protocol DataAPI: API {
    var headers: HTTPHeaders? { get }
    var params: [String: Sendable]? { get }
    var encoding: ParameterEncoding { get }
}

public protocol UploadAPI: API {
    var multipartFormData: MultipartFormData? { get }
}
