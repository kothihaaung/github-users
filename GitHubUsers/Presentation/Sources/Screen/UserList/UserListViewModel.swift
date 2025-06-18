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
    @Published private(set) var isLoadingMore: Bool = false
    @Published private(set) var users: [User] = []
    @Published private(set) var isError = false
    
    private let gitHubUseCases: GitHubUseCasesConvertible
    
    // Pagination page size
    private let perPage = 30
    
    private var nextSince: Int?
    
    init(gitHubUseCases: GitHubUseCasesConvertible = GitHubUseCases()) {
        self.gitHubUseCases = gitHubUseCases
    }
    
    func load(more: Bool = false) async {
        if more && nextSince == nil {
            return
        }
        
        self.isError = false
        self.isLoading = !more
        self.isLoadingMore = more
        
        do {
            let result = try await gitHubUseCases
                .getUsers
                .execute(since: nextSince ?? 0, perPage: perPage)
            
            users.append(contentsOf: result.users)
           
            self.nextSince = result.nextSince
            
        } catch {
            self.isError = true
            print("log: error: loadUsers: \(error)")
        }
        
        self.isLoading = false
        self.isLoadingMore = false
    }
}
