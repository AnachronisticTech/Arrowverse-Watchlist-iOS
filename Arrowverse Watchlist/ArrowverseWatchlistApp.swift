//
//  ArrowverseWatchlistApp.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 18/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import TheMovieDBKit
import ATCommon
import ATiOS

@main
struct ArrowverseWatchlistApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var appIconManager = AppIconManager(PrimaryAppIcon(), alternatives: [], Utils.logger)
    @StateObject private var crossPromoAppsManager = CrossPromoAppsManager(appIdentifier: Bundle.main.bundleIdentifier, showAllApps: true)
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var store = Store(
        donationIds: [
            "com.anachronistictech.smalltip",
            "com.anachronistictech.mediumtip",
            "com.anachronistictech.largetip"
        ],
        Utils.logger
    )

    init() {
        TheMovieDB.setToken(Constants.apiKey)
    }

    var body: some Scene {
        WindowGroup {
            ShowsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.logger, Utils.logger)
                .environment(\.appIconManager, appIconManager)
                .environment(\.crossPromoAppsManager, crossPromoAppsManager)
                .environment(\.themeManager, themeManager)
                .environment(\.store, store)
                .tint(themeManager.accentColor)
                .preferredColorScheme(themeManager.scheme)
        }
    }
}
