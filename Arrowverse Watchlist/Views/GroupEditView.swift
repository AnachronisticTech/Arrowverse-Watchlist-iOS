//
//  GroupEditView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 10/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI
import Introspect

struct GroupEditView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var groupName: String = ""

    private var group: SeriesCollection
    private var request: FetchRequest<Series>
    private var shows: FetchedResults<Series> {
        request.wrappedValue
    }

    private let title: String

    init(creating group: SeriesCollection) {
        self.group = group
        request = FetchRequest<Series>(fetchRequest: DatabaseManager.getSeries(for: group))
        title = "Add a new group"
    }

    init(updating group: SeriesCollection) {
        self.group = group
        request = FetchRequest<Series>(fetchRequest: DatabaseManager.getSeries(for: group))
        title = "Update a group"
        _groupName = State(initialValue: group.name)
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Name", text: $groupName)
                        .textFieldStyle(.roundedBorder)

                    NavigationLink {
                        ShowSearchView(group: group)
                    } label: {
                        HStack {
                            Text("Add show")
                                .font(.body)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.blue)
                            Image(systemName: "plus.circle.fill")
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            Capsule()
                                .foregroundColor(Color(UIColor.systemGray5))
                        )
                    }
                }
                .padding()

                List {
                    Section(header: titleView("Shows")) {
                        ForEach(shows) { show in
                            ShowView(show: show)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewContext.rollback()
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        group.name = groupName
                        group.isCreated = true

                        do {
                            try viewContext.save()
                        } catch {
                            print("Failed to save group with error: \(error)")
                        }

                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(groupName.isEmpty)
                }
            }
        }
        .introspectViewController { view in
            view.isModalInPresentation = true
        }
    }

    @ViewBuilder private func titleView(_ text: String) -> some View {
        HStack {
            Spacer()
            Text(text)
                .font(.title)
            Spacer()
        }
        .padding([.top])
    }
}

struct GroupEditView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationView {
                GroupEditView(creating: SeriesCollection(context: PersistenceController.preview.container.viewContext))
            }
            Divider()
            NavigationView {
                GroupEditView(updating: PersistenceController.group)
            }
        }
    }
}
