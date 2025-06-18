//
//  NavigationManager.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/15.
//

import Foundation

public class NavigationManager: ObservableObject {
    public init() {}
    
    @Published public var path: [Path] = []
}

extension NavigationManager {
    public enum Path: Hashable {
        case userDetail(String)
    }
}
