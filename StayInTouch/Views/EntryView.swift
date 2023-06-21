//
//  ContentView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/25/23.
//

import SwiftUI
import CoreData

struct EntryView: View {
    @State private var currentView = "Call List"
    let topLevelViews = ["Call List", "Contacts"]

    var body: some View {
        // TODO: Navigation View is required to have Toolbar Items properly aligned.
        NavigationView {
            VStack {
                switch currentView {
                case "Call List":
                    CallListView()
                case "Contacts":
                    ContactsView()
                default:
                    Text("No View found")
                }
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("main view", selection: $currentView) {
                        ForEach(topLevelViews, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }
            }
            .navigationBarTitle("", displayMode: .inline) // Inline mode helps to hide the titlebar space.
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
