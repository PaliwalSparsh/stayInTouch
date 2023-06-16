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
        VStack {
            Picker("main view", selection: $currentView) {
                ForEach(topLevelViews, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
            .padding(.vertical, 24)

            switch currentView {
            case "Call List":
                CallListView()
            case "Contacts":
                ContactsView()
            default:
                Text("No View found")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
