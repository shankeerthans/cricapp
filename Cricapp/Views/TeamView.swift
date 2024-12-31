//
//  TeamView.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-11.
//

import SwiftUI

struct TeamView: View {
    @ObservedObject var team: Team
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(team.teamName ?? "Unknown")
                    .foregroundStyle(.foreground)
                    .font(.headline)
                Text(team.teamSName ?? "Unknown")
                    .foregroundStyle(.foreground)
                    .font(.footnote)
            }
            Spacer()
            if let data = team.image, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .border(.foreground, width: 2)
                    .clipShape(.rect(cornerRadius: 4))
                    
            } else {
                Image(systemName: "list.bullet.rectangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .border(.foreground, width: 2)
                    .clipShape(.rect(cornerRadius: 4))
            }
        }
    }
}

#Preview {
    TeamView(team: Team())
}
