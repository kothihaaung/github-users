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
    var getUserDetail: GetUserDetailCaseConvertible { get }
}

@MainActor
public class GitHubUseCases: GitHubUseCasesConvertible {
    public init() {}
    public let getUsers: GetUsersUseCaseConvertible = GetUsersUseCase(repo: GitHubRepo.shared)
    public let getUserDetail: GetUserDetailCaseConvertible = GetUserDetailUseCase(repo: GitHubRepo.shared)
}
