//
//  GitHubUsersTests.swift
//  GitHubUsersTests
//
//  Created by Thiha the Dev on 2025/06/14.
//

import XCTest
@testable import Domain

final class GitHubUsersTests: XCTestCase {
    func test_GetUsersUseCase() async throws {
        let repo = MockGitHubRepo.shared
        repo.error = nil
        repo.shouldReturnNextSince = false
        
        let sut = GetUsersUseCase(repo: repo)
        let result = try await sut.execute(since: 0, perPage: 30)
        
        XCTAssertTrue(result.users[0].login == "mojombo")
        XCTAssertTrue(result.nextSince == nil)
    }
    
    func test_GetUsersUseCase_WithNextSince() async throws {
        let repo = MockGitHubRepo.shared
        repo.error = nil
        repo.shouldReturnNextSince = true
        
        let sut = GetUsersUseCase(repo: repo)
        let result = try await sut.execute(since: 0, perPage: 30)
        
        XCTAssertTrue(result.users[0].login == "mojombo")
        XCTAssertTrue(result.nextSince == 46)
    }
    
    func test_GetUsersUseCase_Error() async {
        let repo = MockGitHubRepo.shared
        repo.error = .someError

        let sut = GetUsersUseCase(repo: repo)

        do {
            _ = try await sut.execute(since: 0, perPage: 30)
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertEqual(error as? MockError, .someError)
        }
    }
    
    func test_GetUserDetailWithReposUseCase() async throws {
        let repo = MockGitHubRepo.shared
        repo.error = nil
        repo.shouldReturnNextPage = false
        
        let sut = GetUserDetailWithReposUseCase(repo: repo)
        let result = try await sut.execute(login: "defunkt", perPage: 10, page: 0)
        
        XCTAssertTrue(result.0.login == "defunkt")
        XCTAssertTrue(result.1[0].name == "acts_as_textiled")
        XCTAssertTrue(result.2 == nil)
    }
    
    func test_GetUserDetailWithReposUseCase_WithNextPage() async throws {
        let repo = MockGitHubRepo.shared
        repo.error = nil
        repo.shouldReturnNextPage = true
        
        let sut = GetUserDetailWithReposUseCase(repo: repo)
        let result = try await sut.execute(login: "defunkt", perPage: 30, page: 0)
        
        XCTAssertTrue(result.detail.login == "defunkt")
        XCTAssertTrue(result.repos[0].name == "acts_as_textiled")
        XCTAssertTrue(result.nextPage == 1)
    }
    
    func test_GetUserDetailWithReposUseCase_Error() async {
        let repo = MockGitHubRepo.shared
        repo.error = .someError

        let sut = GetUserDetailWithReposUseCase(repo: repo)

        do {
            _ = try await sut.execute(login: "defunkt", perPage: 30, page: 0)
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertEqual(error as? MockError, .someError)
        }
    }
}
