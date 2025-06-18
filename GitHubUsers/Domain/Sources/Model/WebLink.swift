//
//  WebLink.swift
//  Domain
//
//  Created by Thiha the Dev on 2025/06/17.
//

import Foundation

public struct WebLink: Identifiable {
    public init(url: URL) {
        self.url = url
    }
    public let id = UUID()
    public let url: URL
}
