//
//  UserDetailViewModel.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/15.
//

import Foundation
import Domain
import Di

@MainActor
class UserDetailViewModel: ObservableObject {
    @Published private(set) var isLoading = true
    @Published private(set) var userDetail: Domain.UserDetail?
    @Published private(set) var userRepos: [Domain.Repo] = []
    
    private let gitHubUseCases: GitHubUseCasesConvertible
    
    init(gitHubUseCases: GitHubUseCasesConvertible = GitHubUseCases()) {
        self.gitHubUseCases = gitHubUseCases
    }
    
    func load(login: String) async {
        self.isLoading = true
        
        do {
            let result = try await gitHubUseCases
                .getUserDetailWithRepos
                .execute(login: login, perPage: 50)
            
            self.userDetail = result.0
            self.userRepos = result.1
            
        } catch {
            print("log: error: loadUserDetailWithRepos: \(error)")
        }
        
        self.isLoading = false
    }
}
