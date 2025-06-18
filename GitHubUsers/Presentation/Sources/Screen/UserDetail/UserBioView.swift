//
//  UserBioView.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/17.
//

import SwiftUI
import SDWebImageSwiftUI

public struct UserBioView: View {
    public let login: String
    public let avatarURL: String?
    public let name: String?
    public let bio: String?
    
    public var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AnimatedImage(url: URL(string: avatarURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name ?? "")
                    .font(.title3).bold()
                
                Text(login)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let bio = bio, !bio.isEmpty {
                    Text(bio)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
            }
            
            Spacer()
        }
    }
}
