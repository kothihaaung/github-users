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
    @Published private(set) var isLoading = true
    @Published private(set) var users: [User] = []
    
    private let gitHubUseCases: GitHubUseCasesConvertible
    
    init(gitHubUseCases: GitHubUseCasesConvertible = GitHubUseCases()) {
        self.gitHubUseCases = gitHubUseCases
    }
    
    func loadUsers() async {
        self.isLoading = true
        
        do {
            let result = try await gitHubUseCases
                .getUsers
                .execute(since: 0, perPage: 50)
            
            users = result.users
            
            print("users count: \(users.count)")
            print("next since: \(result.nextSince ?? 0)")
            
        } catch {
            print("log: error: loadUsers: \(error)")
        }
        
        self.isLoading = false
    }
}
