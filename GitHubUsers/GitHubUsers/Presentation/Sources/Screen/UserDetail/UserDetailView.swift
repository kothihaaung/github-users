//
//  UserDetailView.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/16.
//

import SwiftUI
import SDWebImageSwiftUI
import Domain

public struct UserDetailView: View {
    let login: String
    
    @StateObject private var viewModel = UserDetailViewModel()
    @State private var selectedWebLink: WebLink?
    
    private var detail: Domain.UserDetail? { viewModel.userDetail }
    private var repos: [Domain.Repo]? { viewModel.userRepos }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    AnimatedImage(url: URL(string: detail?.avatarURL ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(detail?.name ?? "")
                            .font(.title3)
                            .bold()
                        
                        Text(login)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let bio = detail?.bio, !bio.isEmpty {
                            Text(bio)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                HStack(spacing: 24) {
                    if let followers = detail?.followers {
                        StatView(label: "Followers", value: followers)
                    }
                    if let following = detail?.following {
                        StatView(label: "Following", value: following)
                    }
                    if let repos = detail?.publicRepos {
                        StatView(label: "Repos", value: repos)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                if let repos = repos, !repos.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Repositories")
                            .font(.title3)
                            .bold()
                        
                        ForEach(repos, id: \.id) { repo in
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

                                }
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top)
                }
                
                Spacer()
                
            }
            .padding()
        }
        .task {
            await viewModel.load(login: login)
        }
        .sheet(item: $selectedWebLink) { webLink in
            SafariView(url: webLink.url)
        }
    }
}

private struct StatView: View {
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

