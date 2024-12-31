//
//  PlayersListView.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//

import SwiftUI
import CoreData

struct PlayersListView: View {
    @ObservedObject var team: Team
    @Environment(\.managedObjectContext) var viewContext: NSManagedObjectContext
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            FetchedObjects(predicate: buildPredicate(),
                           sortDescriptors: buildSortDescriptors()) { (players: [Player]) in
                List(players, id: \.self) { player in
                    PlayerView(player: player)
                }
                .searchable(text: $searchText, prompt: "Search Player")
                .navigationTitle("Players")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Task {
                                await URLSessionManager.shared.fetch(data: .players(teamId: Int(truncating: team.teamId!)), in: viewContext)
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24)
                                .foregroundStyle(.foreground)
                        }
                        .frame(width: 24)
                    }
                }
            }
        }
        .task {
            if team.toPlayer == nil || team.toPlayer!.allObjects.isEmpty {
                await URLSessionManager.shared.fetch(data: .players(teamId: Int(truncating: team.teamId!)), needToDelete: false, in: viewContext)
            }
        }
    }
    
    private func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            NSPredicate(format: "fromTeam == %@", team)
        } else {
            NSPredicate(format: "fromTeam == %@ AND name CONTAINS[cd] %@", team, searchText)
        }
    }
    
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    }
}

#Preview {
    PlayersListView(team: Team())
}
