//
//  ErrorView.swift
//  Presentation
//
//  Created by Thiha the Dev on 2025/06/18.
//

import SwiftUI

struct ErrorView: View {
    var message: String
    var retryAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Text("⚠️")
                .font(.headline)

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)

            if let retry = retryAction {
                Button(action: retry) {
                    Text("Retry")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(radius: 4)
        )
        .padding()
    }
}
