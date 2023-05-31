//
//  ContentView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/25/23.
//

import SwiftUI
import CoreData

struct EntryView: View {
    var body: some View {
        TabView {
            CallListView().tabItem {
                Label("Call List", systemImage: "list.bullet.rectangle.portrait.fill")
            }
            ContactsView().tabItem {
                Label("Contacts", systemImage: "person.crop.rectangle.stack.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
