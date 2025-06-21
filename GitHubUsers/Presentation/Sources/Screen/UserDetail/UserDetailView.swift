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
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if viewModel.isError {
                ErrorView(message: "Something went wrong!") {
                    Task {
                        await viewModel.loadUserDetailAndRepos(login: login)
                    }
                }
                
            } else {
                userDetail
            }
        }
        .task {
            await viewModel.loadUserDetailAndRepos(login: login)
        }
    }
}

extension UserDetailView {
    private var userDetail: some View {
        List {
            if detail != nil {
                Section {
                    UserBioView(login: login,
                                avatarURL: detail?.avatarURL,
                                name: detail?.name,
                                bio: detail?.bio)
                        .listRowSeparator(.hidden)
                }
                
                Section {
                    UserStatGroupView(followers: detail?.followers,
                                      following: detail?.following,
                                      repos: detail?.publicRepos)
                        .listRowSeparator(.hidden)
                }
            }
            
            if let repos = repos {
                Section(header: Text("Repositories").font(.title3).bold()) {
                    ForEach(repos, id: \.id) { repo in
                        RepoRow(repo: repo, selectedWebLink: $selectedWebLink)
                            .onAppear {
                                if repo.id == repos.last?.id {
                                    Task {
                                        await viewModel.loadMoreRepos(login: login)
                                    }
                                }
                            }
                    }
                    
                    if viewModel.isLoadingMore {
                        LoadingMorView()
                    }
                }
            }
        }
        .listStyle(.inset)
        .sheet(item: $selectedWebLink) { webLink in
            SafariView(url: webLink.url)
        }
    }
}
