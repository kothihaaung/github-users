import Domain
import Combine
import Foundation

public final class MockGitHubRepo: GitHubRepoConvertible, @unchecked Sendable {
    public static var shared = MockGitHubRepo()

    var shouldReturnNextSince = false
    var shouldReturnNextPage = false
    var error: MockError?

    public func getUsers(since: Int, perPage: Int) -> AnyPublisher<(users: [User], nextSince: Int?), Error> {
        guard error == nil else {
            return .fail(with: error!)
        }
        
        let users: [User] = try! readJSONFromFile(fileName: "users")
        let nextSince = shouldReturnNextSince ? (users.last?.id ?? since + 1) : nil
        return .just((users: users, nextSince: nextSince))
    }

    public func getUserDetail(login: String) -> AnyPublisher<UserDetail, Error> {
        guard error == nil else {
            return .fail(with: error!)
        }
        
        let userDetail: UserDetail = try! readJSONFromFile(fileName: "user-detail")
        return .just(userDetail)
    }

    public func getUserRepos(login: String, perPage: Int, page: Int) -> AnyPublisher<(repos:[Repo], nextPage: Int?), Error> {
        guard error == nil else {
            return .fail(with: error!)
        }
        
        let repos: [Repo] = try! readJSONFromFile(fileName: "repos")
        let nextPage = shouldReturnNextPage ? page + 1 : nil
        return .just((repos: repos, nextPage: nextPage))
    }
}

public enum MockError: Error {
    case someError
}
