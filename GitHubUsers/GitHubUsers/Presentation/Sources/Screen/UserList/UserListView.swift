//
//  UserListView.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/14.
//

import SwiftUI

@available(iOS 16.0, *)
public struct UserListView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel = UserListViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                userList
            }
        }
        .task {
            if viewModel.users.isEmpty {
                await viewModel.loadUsers()
            }
        }
    }
}

@available(iOS 16.0, *)
extension UserListView {
    private var userList: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                List(viewModel.users, id: \.id) { user in
                    UserRow(login: user.login, avatarUrl: user.avatarURL)
                        .onTapGesture {
                            navigationManager.path.append(.userDetail(user.login))
                        }
                }
            }
            .navigationDestination(for: NavigationManager.Path.self) { path in
                switch path {
                case .userDetail(let login):
                    UserDetailView(login: login)
                }
            }
        }
    }
}
