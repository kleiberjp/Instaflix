//
//  InstaflixApp.swift
//  Instaflix
//
//  Created by Kleiber Perez on 10/09/24.
//

import SwiftUI

@main
struct InstaflixApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
