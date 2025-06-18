//
//  UserStatGroupView.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/17.
//

import SwiftUI

public struct UserStatGroupView: View {
    public let followers: Int?
    public let following: Int?
    public let repos: Int?
    
    public var body: some View {
        HStack(spacing: 24) {
            if let followers = self.followers {
                UserStatView(label: "Followers", value: followers)
            }
            if let following = self.following {
                UserStatView(label: "Following", value: following)
            }
            if let repos = self.repos {
                UserStatView(label: "Repos", value: repos)
            }
        }
    }
}
