//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Thiha the Dev on 2025/06/14.
//

import SwiftUI
import Presentation

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some View {
        UserList()
            .environmentObject(navigationManager)
    }
}
