//
//  InstaflixApp.swift
//  Instaflix
//
//  Created by Kleiber Perez on 10/09/24.
//

import SwiftUI

let isRunningUITest = ProcessInfo.processInfo.isRunningUITests

@main
struct InstaflixApp: App {

    let coreData: PersistanceDBManager
    
    @StateObject var viewModel: MainViewModel = MainViewModel()
    
    init() {
        DIContainer.shared.registerInjections()
        coreData = DIContainer.shared.inject(type: PersistanceDBManager.self)!
    }
    
    var body: some Scene {
        WindowGroup {
            MainCoordinator(viewModel: viewModel)
                .environment(\.managedObjectContext, coreData.viewContext)
        }
    }
}
