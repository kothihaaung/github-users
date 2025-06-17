//
//  UserStatView.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/17.
//

import SwiftUI

struct UserStatView: View {
    let label: String
    let value: Int
    
    var iconName: String {
        switch label.lowercased() {
        case "followers": return "person.2.fill"
        case "following": return "arrow.right.circle.fill"
        case "repos":     return "folder.fill"
        default:          return "questionmark.circle"
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text("\(value)")
                .font(.headline)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
