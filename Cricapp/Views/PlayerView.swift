//
//  PlayerView.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-11.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var player: Player
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Group {
                    Text("NAME")
                        .font(.footnote)
                    Text(player.name ?? "Unknown")
                        .font(.subheadline.bold())
                        .padding(.bottom, 4)
                }
                .foregroundStyle(.foreground)
                
                Group {
                    Text("BATTING STYLE")
                        .font(.footnote)
                    Text(player.battingStyle ?? "Unknown")
                        .font(.subheadline.bold())
                        .padding(.bottom, 4)
                }
                .foregroundStyle(.foreground)
                
                Group {
                    Text("BOWLING STYLE")
                        .font(.footnote)
                    Text(player.bowlingStyle ?? "Unknown")
                        .font(.subheadline.bold())
                }
                .foregroundStyle(.foreground)
            }
            Spacer()
            if let data = player.image, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(.circle)
                    .padding(.all, 1)
                    .overlay(content: {
                        Circle()
                            .stroke(lineWidth: 2)
                    })
                    .padding(.vertical, 8)
                    .padding(.trailing, 8)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(.circle)
                    .padding(.all, 1)
                    .overlay(content: {
                        Circle()
                            .stroke(lineWidth: 2)
                    })
                    .padding(.vertical, 8)
                    .padding(.trailing, 8)
            }
        }
    }
}

#Preview {
    PlayerView(player: Player())
}
