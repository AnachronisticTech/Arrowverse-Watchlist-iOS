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
            NSSortDescriptor(keyPath: \ShowGroupDB.name, ascending: true)
        ],
        predicate: NSPredicate(format: "isCreated == %@", NSNumber(value: true))
    )
    private var groups: FetchedResults<ShowGroupDB>

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
                                viewContext.delete(group)

                                do {
                                    try viewContext.save()
                                } catch {
                                    print("Could not delete object \(group): \(error)")
                                }
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

                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Show")
                        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                        do {
                            try viewContext.execute(batchDelete)
                            try viewContext.save()
                        } catch {
                            print("Could not delete shows with error \(error)")
                        }

                        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowGroup")
                        let batchDelete2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)

                        do {
                            try viewContext.execute(batchDelete2)
                            try viewContext.save()
                        } catch {
                            print("Could not delete showgroups with error \(error)")
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .sheet(item: $activeSheet) { mode in
            switch mode {
                case .add:
                    GroupEditView(creating: ShowGroupDB(context: viewContext))
                case .edit(let group):
                    GroupEditView(updating: group)
            }
        }
    }

    enum ActiveSheet: Identifiable {
        case add
        case edit(ShowGroupDB)

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
    }
}
