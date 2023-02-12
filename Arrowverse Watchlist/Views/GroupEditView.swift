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
    @State private var red: Double = 0
    @State private var green: Double = 0
    @State private var blue: Double = 0
    @State private var icon: String = ""

    @ObservedObject private var group: SeriesCollection

    private let title: String

    init(creating group: SeriesCollection) {
        self.group = group
        title = "Add a new group"
    }

    init(updating group: SeriesCollection) {
        self.group = group
        title = "Update a group"
        _groupName = State(initialValue: group.name)
        _red = State(initialValue: Double(group.red))
        _green = State(initialValue: Double(group.green))
        _blue = State(initialValue: Double(group.blue))
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $groupName)
                    .textFieldStyle(.roundedBorder)

                HStack(alignment: .center) {
                    VStack {
                        HStack(spacing: 20) {
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                            Slider(value: $red, in: 0...255, step: 1)
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 25, height: 25)
                            Slider(value: $green, in: 0...255, step: 1)
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 25, height: 25)
                            Slider(value: $blue, in: 0...255, step: 1)
                        }
                    }

                    ZStack {
                        Circle()
                            .foregroundColor(Color(.sRGB, red: red/255, green: green/255, blue: blue/255, opacity: 1))

                        if let data = Data(base64Encoded: icon, options: .ignoreUnknownCharacters), let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100 * cos(45), height: 100 * cos(45))
                        }
                    }
                    .frame(width: 100, height: 100)
                }
                .frame(height: 110)

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
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(Color(UIColor.systemGray5))
                    )
                }

                List {
                    ForEach(group.shows) { show in
                        Text(show.name)
                    }
                }
            }
            .padding()
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
                        group.red = Int16(red)
                        group.green = Int16(green)
                        group.blue = Int16(blue)
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
}

struct GroupEditView_Previews: PreviewProvider {
    static var showGroup: SeriesCollection = {
        let group = SeriesCollection()
        group.name = "Stargate"
        group.red = 22
        group.green = 75
        group.blue = 123
        return group
    }()

    static var previews: some View {
        VStack {
            NavigationView {
                GroupEditView(creating: SeriesCollection(context: PersistenceController.preview.container.viewContext))
            }
            Divider()
            NavigationView {
                GroupEditView(updating: showGroup)
            }
        }
    }
}
