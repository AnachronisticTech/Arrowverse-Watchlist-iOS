//
//  ShowsView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 27/08/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI
import CoreData
import ATCommon
import ATiOS

struct ShowsView: View {
    @Environment(\.managedObjectContext) var viewContext

    @State private var activeSheet: ActiveSheet?

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \SeriesCollection.name, ascending: true)
        ],
        predicate: NSPredicate(format: "isCreated == %@", NSNumber(value: true))
    )
    private var groups: FetchedResults<SeriesCollection>

    var body: some View {
        NavigationStack {
            List {
                ForEach(groups) { group in
//                    NavigationLink {
//                        GroupMainView(group: group)
//                    } label: {
//                        ShowGroupView(group: group)
//                    }
                    ShowGroupView(group: group)
                        .listRowInsets(.init())
                        .background(
                            NavigationLink {
                                GroupMainView(group: group)
                                    .navigationTitle(group.name)
                            } label: {
                                Rectangle()
                                    .opacity(0)
                            }
                            .opacity(0)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button("Edit", systemImage: "pencil.circle") {
                                activeSheet = .edit(group)
                            }

                            Divider()

                            Button("Delete", systemImage: "trash", role: .destructive) {
                                DatabaseManager.delete(group)
                            }
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }

                ToolbarItem {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "pencil.circle")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .sheet(item: $activeSheet) { mode in
            switch mode {
                case .add:
                    GroupEditView(creating: SeriesCollection(context: viewContext))
                case .edit(let group):
                    GroupEditView(updating: group)
            }
        }
    }

    enum ActiveSheet: Identifiable {
        case add
        case edit(SeriesCollection)

        var id: Int {
            switch self {
                case .add: return 0
                case .edit: return 1
            }
        }
    }
}

struct ShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
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
