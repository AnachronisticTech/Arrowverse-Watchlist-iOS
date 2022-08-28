//
//  Arrowverse_Watchlist_2App.swift
//  Arrowverse Watchlist 2
//
//  Created by Daniel Marriner on 18/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import TVDBKit

@main
struct Arrowverse_Watchlist_2App: App {
    let persistenceController = PersistenceController.shared
    let showDataStore = ShowDataStore.shared

    init() {
        TVDB.setToken(Constants.apiKey)
    }

    var body: some Scene {
        WindowGroup {
            EpisodeListView()
                .environmentObject(showDataStore)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
