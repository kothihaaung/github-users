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
        List {
            if detail != nil {
                Section {
                    userHeaderSection
                }

                Section {
                    statSection
                }
            }

            if let repos = repos {
                Section(header: Text("Repositories").font(.title3).bold()) {
                    ForEach(repos, id: \.id) { repo in
                        repoRow(repo)
                            .onAppear {
                                if repo.id == repos.last?.id {
                                    Task {
                                        await viewModel.load(login: login, more: true)
                                    }
                                }
                            }
                    }

                    if viewModel.isLoadingMoreRepos {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
        .sheet(item: $selectedWebLink) { webLink in
            SafariView(url: webLink.url)
        }
        .task {
            await viewModel.load(login: login)
        }
    }

    // MARK: - Sections

    private var userHeaderSection: some View {
        HStack(alignment: .top, spacing: 16) {
            AnimatedImage(url: URL(string: detail?.avatarURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))

            VStack(alignment: .leading, spacing: 4) {
                Text(detail?.name ?? "")
                    .font(.title3).bold()

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
    }

    private var statSection: some View {
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
    }

    private func repoRow(_ repo: Domain.Repo) -> some View {
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

// MARK: - StatView

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
