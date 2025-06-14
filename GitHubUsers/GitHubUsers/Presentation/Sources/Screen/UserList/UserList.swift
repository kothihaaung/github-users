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
        Text("UserList")
            .task {
                await viewModel.load()
            }
    }
}
