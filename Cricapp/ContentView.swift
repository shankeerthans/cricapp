//
//  ContentView.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            TeamsListView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
