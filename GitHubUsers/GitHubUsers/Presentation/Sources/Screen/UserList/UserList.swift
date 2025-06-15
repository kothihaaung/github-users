//
//  UserList.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/14.
//

import SwiftUI

public struct UserList: View {
    @StateObject private var viewModel = UserListViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack {
            List(viewModel.users, id: \.id) { user in
                UserRow(login: user.login, avatarUrl: user.avatarURL)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
