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
                
            } else if viewModel.isError {
                ErrorView(message: "Something went wrong!") {
                    Task {
                        await viewModel.load()
                    }
                }
            } else {
                userList
            }
        }
        .task {
            if viewModel.users.isEmpty {
                await viewModel.load()
            }
        }
    }
}

@available(iOS 16.0, *)
extension UserListView {
    private var userList: some View {
        NavigationStack(path: $navigationManager.path) {
            List {
                ForEach(viewModel.users, id: \.id) { user in
                    UserRow(login: user.login, avatarUrl: user.avatarURL)
                        .onAppear {
                            if user.id == viewModel.users.last?.id {
                                Task {
                                    await viewModel.load(more: true)
                                }
                            }
                        }
                        .onTapGesture {
                            navigationManager.path.append(.userDetail(user.login))
                        }
                }
                
                if viewModel.isLoadingMore {
                    LoadingMorView()
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
