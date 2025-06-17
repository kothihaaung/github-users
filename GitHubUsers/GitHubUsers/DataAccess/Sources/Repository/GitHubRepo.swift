//
//  GitHubRepo.swift
//  DataAccess
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Domain
import Combine
import Foundation

public final class GitHubRepo: GitHubRepoConvertible, @unchecked Sendable {
    public static let shared = GitHubRepo()
    
    private let network: NetworkConvertible
    
    public init(network: NetworkConvertible = Network()) {
        self.network = network
    }
    
    public func getUsers(since: Int, perPage: Int) -> AnyPublisher<(users: [User], nextSince: Int?), Error> {
        let api: GitHubAPI = .users(since: since, perPage: perPage)

        let publisher: AnyPublisher<Response<[User]>, Error> = network.run(api)

        return publisher
            .map { response in
                let nextSince = self.extractNextSince(from: response.response)
                return (users: response.value, nextSince: nextSince)
            }
            .eraseToAnyPublisher()
    }
    
    public func getUserDetail(login: String) -> AnyPublisher<UserDetail, Error> {
        let api: GitHubAPI = .userDetail(login: login)

        return network.run(api)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    public func getUserRepos(login: String, perPage: Int, page: Int) -> AnyPublisher<(repos:[Repo], nextPage: Int?), Error> {
        let api: GitHubAPI = .repos(login: login, perPage: perPage, page: page)

        let publisher: AnyPublisher<Response<[Repo]>, Error> = network.run(api)

        return publisher
            .map { response in
                let nextPage = self.extractNextPage(from: response.response)
                return (repos: response.value, nextPage: nextPage)
            }
            .eraseToAnyPublisher()
    }
    
    private func extractNextSince(from response: HTTPURLResponse) -> Int? {
        guard let linkHeader = response.value(forHTTPHeaderField: "Link") else {
            return nil
        }

        // Look for the next sence from `rel="next"` link
        let pattern = #"<(.*?)>; rel="next""#
        guard let match = linkHeader.range(of: pattern, options: .regularExpression) else {
            return nil
        }

        let urlPart = String(linkHeader[match])
        guard
            let url = URL(string: urlPart.components(separatedBy: ";").first?.trimmingCharacters(in: CharacterSet(charactersIn: "<>")) ?? ""),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let sinceValue = components.queryItems?.first(where: { $0.name == "since" })?.value,
            let since = Int(sinceValue)
        else {
            return nil
        }

        return since
    }
    
    private func extractNextPage(from response: HTTPURLResponse) -> Int? {
        guard let linkHeader = response.value(forHTTPHeaderField: "Link") else {
            return nil
        }

        let pattern = #"<([^>]+)>;\s*rel="next""#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: linkHeader, range: NSRange(linkHeader.startIndex..., in: linkHeader)),
              let range = Range(match.range(at: 1), in: linkHeader) else {
            return nil
        }

        let nextURLString = String(linkHeader[range])
        guard let url = URL(string: nextURLString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let pageValue = components.queryItems?.first(where: { $0.name == "page" })?.value,
              let page = Int(pageValue) else {
            return nil
        }

        return page
    }
}
