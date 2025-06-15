import SwiftUI
import SDWebImageSwiftUI

struct UserRow: View {
    let login: String
    let avatarUrl: String
    
    var body: some View {
        HStack(spacing: 16) {
            AnimatedImage(url: URL(string: avatarUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))

            Text(login)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
    }
}
