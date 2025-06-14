//
//  UserListViewModel.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/14.
//

import Foundation
import Domain
import Di

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    
    private let githubUseCases: GitHubUseCasesConvertible
    
    init(githubUseCases: GitHubUseCasesConvertible = GitHubUseCases()) {
        self.githubUseCases = githubUseCases
    }
    
    public func load() async {
        await loadUsers()
    }
    
    private func loadUsers() async {
        do {
            users = try await githubUseCases
                .getUsers
                .execute(since: 81, perPage: 50)
            
            print("users count: \(users.count)")
            print("users: \(users)")
            
        } catch {
            print("log: error: loadUsers: \(error)")
        }
    }
}
