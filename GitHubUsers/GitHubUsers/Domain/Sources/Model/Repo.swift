//
//  Repo.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/16.
//

import Foundation

public struct Repo: Decodable, Identifiable, Sendable {
    public let id: Int
    public let nodeID: String
    public let name: String
    public let fullName: String
    public let isPrivate: Bool
    public let htmlURL: String
    public let description: String?
    public let fork: Bool
    public let url: String
    public let createdAt: String
    public let updatedAt: String
    public let pushedAt: String?
    public let gitURL: String
    public let sshURL: String
    public let cloneURL: String
    public let svnURL: String
    public let homepage: String?
    public let size: Int
    public let stargazersCount: Int
    public let watchersCount: Int
    public let language: String?
    public let hasIssues: Bool
    public let hasProjects: Bool
    public let hasDownloads: Bool
    public let hasWiki: Bool
    public let hasPages: Bool
    public let hasDiscussions: Bool
    public let forksCount: Int
    public let archived: Bool
    public let disabled: Bool
    public let openIssuesCount: Int
    public let allowForking: Bool
    public let isTemplate: Bool
    public let visibility: String
    public let forks: Int
    public let openIssues: Int
    public let watchers: Int
    public let defaultBranch: String

    public let owner: Owner

    public struct Owner: Decodable, Sendable {
        public let login: String
        public let id: Int
        public let avatarURL: String
        public let htmlURL: String
        public let type: String
        public let siteAdmin: Bool

        enum CodingKeys: String, CodingKey {
            case login, id
            case avatarURL = "avatar_url"
            case htmlURL = "html_url"
            case type
            case siteAdmin = "site_admin"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case htmlURL = "html_url"
        case description
        case fork
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case svnURL = "svn_url"
        case homepage
        case size
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasDownloads = "has_downloads"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case hasDiscussions = "has_discussions"
        case forksCount = "forks_count"
        case archived
        case disabled
        case openIssuesCount = "open_issues_count"
        case allowForking = "allow_forking"
        case isTemplate = "is_template"
        case visibility
        case forks
        case openIssues = "open_issues"
        case watchers
        case defaultBranch = "default_branch"
        case owner
    }
}
