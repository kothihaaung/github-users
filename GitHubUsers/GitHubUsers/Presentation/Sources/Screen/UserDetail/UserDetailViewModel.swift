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
    @Published private(set) var error: Error?
    @Published private(set) var isLoadingMoreRepos: Bool = false
    
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
        
        print("load: more: \(more)")
        
        self.isLoading = true
        self.isLoadingMoreRepos = more
        
        do {
            let result = try await gitHubUseCases
                .getUserDetailWithRepos
                .execute(login: login, perPage: perPage, page: self.nextPage ?? 1)
            
            self.userDetail = result.0
            self.userRepos.append(contentsOf: result.1)
            
            self.nextPage = result.2
            
        } catch {
            self.error = error
            print("log: error: loadUserDetailWithRepos: \(error)")
        }
        
        self.isLoading = false
        self.isLoadingMoreRepos = false
    }
}
