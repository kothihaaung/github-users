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
    @Published private(set) var isLoadingMore: Bool = false
    @Published private(set) var userDetail: Domain.UserDetail?
    @Published private(set) var userRepos: [Domain.Repo] = []
    @Published private(set) var isError = false
    
    private let gitHubUseCases: GitHubUseCasesConvertible
    
    // Pagination page size
    private let perPage = 30
    
    private var nextPage: Int?
    
    init(gitHubUseCases: GitHubUseCasesConvertible = GitHubUseCases()) {
        self.gitHubUseCases = gitHubUseCases
    }
    
    func load(login: String, more: Bool = false) async {
        if more && nextPage == nil {
            return
        }
        
        self.isError = false
        self.isLoading = !more
        self.isLoadingMore = more
        
        do {
            let result = try await gitHubUseCases
                .getUserDetailWithRepos
                .execute(login: login, perPage: perPage, page: self.nextPage ?? 1)
            
            self.userDetail = result.detail
            self.userRepos.append(contentsOf: result.repos)
            self.nextPage = result.nextPage
            
        } catch {
            self.isError = true
            print("log: error: loadUserDetail: \(error)")
        }
        
        self.isLoading = false
        self.isLoadingMore = false
    }
}
