//
//  UserDetail.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/15.
//

import SwiftUI

public struct UserDetail: View {
    let login: String
    
    @StateObject private var viewModel = UserDetailViewModel()
    
    public var body: some View {
        Text("User Detail: \(String(describing: viewModel.userDetail))")
            .task {
                await viewModel.loadUserDetail(login: login)
            }
    }
}
