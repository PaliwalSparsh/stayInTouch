//
//  StayInTouchApp.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/25/23.
//

import SwiftUI

@main
struct StayInTouchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
