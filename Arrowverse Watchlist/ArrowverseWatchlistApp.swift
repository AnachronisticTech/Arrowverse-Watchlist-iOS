//
//  ArrowverseWatchlistApp.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 18/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import TVDBKit

@main
struct ArrowverseWatchlistApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        TVDB.setToken(Constants.apiKey)
    }

    var body: some Scene {
        WindowGroup {
            ShowsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
