//
//  TeamsListView.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//

import SwiftUI
import CoreData

struct TeamsListView: View {
    @Environment(\.managedObjectContext) var viewContext: NSManagedObjectContext
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            FetchedObjects(predicate: buildPredicate(),
                           sortDescriptors: buildSortDescriptors()) { (teams: [Team]) in
                List(teams, id: \.self) { team in
                    NavigationLink {
                        PlayersListView(team: team)
                    } label: {
                        TeamView(team: team)
                    }
                }
                .searchable(text: $searchText, prompt: "Search Team")
                .navigationTitle("Teams")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Task {
                                await URLSessionManager.shared.fetch(data: .teams, in: viewContext)
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
            if Team.isEmpty(viewContext) {
                await URLSessionManager.shared.fetch(data: .teams, needToDelete: false, in: viewContext)
            }
        }
    }
    
    private func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            NSPredicate(value: true)
        } else {
            NSPredicate(format: "teamName CONTAINS[cd] %@", searchText)
        }
    }
    
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "teamName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    }
}

#Preview {
    TeamsListView()
}
