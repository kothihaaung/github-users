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
    
    private let gitHubUseCases: GitHubUseCasesConvertible
    
    init(gitHubUseCases: GitHubUseCasesConvertible = GitHubUseCases()) {
        self.gitHubUseCases = gitHubUseCases
    }
    
    func loadUserDetail(login: String) async {
        self.isLoading = true
        
        do {
            self.userDetail = try await gitHubUseCases
                .getUserDetail
                .execute(login: login)
            
        } catch {
            print("log: error: loadUserDetail: \(error)")
        }
        
        self.isLoading = false
    }
}
