//
//  RepoRow.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/17.
//

import SwiftUI
import Domain

public struct RepoRow: View {
    public let repo: Domain.Repo
    @Binding public var selectedWebLink: WebLink?
    
    public var body: some View {
        Button {
            if let url = URL(string: repo.htmlURL) {
                selectedWebLink = WebLink(url: url)
            }
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(repo.name)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .bold()
                
                if let desc = repo.description {
                    Text(desc)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 12) {
                    if let language = repo.language {
                        Text(language)
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .overlay(
                                Capsule()
                                    .stroke(Color.blue.opacity(0.7), lineWidth: 1)
                            )
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption2)
                        Text("\(repo.stargazersCount)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
