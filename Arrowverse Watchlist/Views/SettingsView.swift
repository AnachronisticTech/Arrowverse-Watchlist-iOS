//
//  SettingsView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 11/03/2024.
//  Copyright © 2024 Daniel Marriner. All rights reserved.
//

import SwiftUI
import ATCommon
import ATiOS

struct SettingsView: View {
    @Environment(\.logger) private var logger
    @Environment(\.appIconManager) private var appIconManager

    var body: some View {
        List {
            DebugView {
                Section(header: Text("Debug")) {
                    Button("Delete Data") {
                        logger.log(.notice, message: "Deleting all data")
                        DatabaseManager.deleteAll()
                    }
                }
            }

            Section(header: Text("User Interface")) {
                ThemeConfigurationView()
            }

            if appIconManager.availableIcons.count > 1 {
                Section(header: Text("App Icon")) {
                    NavigationLink {
                        AppIconPickerView()
                            .navigationTitle("Select Icon")
                            .background(Color(uiColor: .secondarySystemBackground))
                    } label: {
                        HStack {
                            Text("Select app icon")
                            Spacer()
                            CurrentAppIconView()
                        }
                    }
                }
            }

            Section(header: Text("Support the developer")) {
                NavigationLink {
                    DonationsView()
                        .navigationTitle("Give a tip")
                } label: {
                    Text("Give a tip")
                }

                NavigationLink {
                    CrossPromoAppsView()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .navigationTitle("Other Apps")
                } label: {
                    Text("Other apps")
                }

//                CellButton("Share") {}
            }
        }
        .navigationTitle("Settings")
        .listStyle(.grouped)
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environment(\.appIconManager, AppIconManager(PrimaryAppIcon(), alternatives: []))
            .environment(\.store, Store(
                donationIds: [
                    "com.anachronistictech.smalltip",
                    "com.anachronistictech.mediumtip",
                    "com.anachronistictech.largetip"
                ]
            ))
    }
}
