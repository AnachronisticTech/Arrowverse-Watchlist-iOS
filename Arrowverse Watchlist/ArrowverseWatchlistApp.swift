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
    let showDataStore = ShowDataStore.shared

    let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    init() {
        TVDB.setToken(Constants.apiKey)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                EpisodeListView_New(groupManager: GroupManager(config, 0))
//            ShowsView()
//            EpisodeListView()
//                .environmentObject(showDataStore)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct Utils {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static func episodeSorting(_ e1: WatchableEpisode, _ e2: WatchableEpisode) -> Bool {
        (e1.airDate, e1.episodeNumber) < (e2.airDate, e2.episodeNumber)
    }
}
