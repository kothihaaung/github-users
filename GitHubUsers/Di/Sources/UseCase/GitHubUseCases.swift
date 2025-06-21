//
//  GitHubUseCases.swift
//  Di
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Foundation
import Domain
import DataAccess

public protocol GitHubUseCasesConvertible {
    var getUsers: GetUsersUseCaseConvertible { get }
    var getUserDetailWithRepos: GetUserDetailWithReposUseCaseConvertible { get }
    var getRepos: GetReposUseCaseConvertible { get }
}

public class GitHubUseCases: GitHubUseCasesConvertible {
    public init() {}
    public let getUsers: GetUsersUseCaseConvertible = GetUsersUseCase(repo: GitHubRepo.shared)
    public let getUserDetailWithRepos: GetUserDetailWithReposUseCaseConvertible = GetUserDetailWithReposUseCase(repo: GitHubRepo.shared)
    public let getRepos: GetReposUseCaseConvertible = GetReposUseCase(repo: GitHubRepo.shared)
}
