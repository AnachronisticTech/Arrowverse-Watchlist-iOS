//
//  ShowsView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 27/08/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI
import CoreData

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

    let columns: [GridItem] = [GridItem(), GridItem()]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(groups) { group in
                        NavigationLink {
                            GroupMainView(group: group)
                                .navigationTitle(group.name)
                        } label: {
                            ShowGroupView(group: group)
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button("Edit") {
                                activeSheet = .edit(group)
                            }
                            Button("Delete") {
                                DatabaseManager.delete(group)
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "pencil.circle")
                    }
                }

                #if DEBUG
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        DatabaseManager.deleteAll()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                #endif
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
    }
}
