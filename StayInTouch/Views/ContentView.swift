//
//  ContentView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/25/23.
//

import SwiftUI
import CoreData
import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        PeopleView()
        // WelcomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
