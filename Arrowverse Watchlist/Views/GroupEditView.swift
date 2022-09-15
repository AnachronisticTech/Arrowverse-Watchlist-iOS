//
//  GroupEditView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 10/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct GroupEditView: View {
    @State private var groupName: String = ""
    @State private var red: Double = 0
    @State private var green: Double = 0
    @State private var blue: Double = 0
    @State private var icon: String = ""

    private let title: String

    init() {
        title = "Add a new group"
    }

    init(_ group: ShowGroup) {
        title = "Update a group"
        _groupName = State(initialValue: group.name)
        _red = State(initialValue: Double(group.color.r))
        _green = State(initialValue: Double(group.color.g))
        _blue = State(initialValue: Double(group.color.b))
        _icon = State(initialValue: group.icon)
    }

    var body: some View {
        VStack {
            TextField("Name", text: $groupName)
                .textFieldStyle(.roundedBorder)

            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Red")
                    Spacer()
                    Text("Green")
                    Spacer()
                    Text("Blue")
                }
                .padding(.vertical, 5)

                VStack {
                    Slider(value: $red, in: 0...255, step: 1)
                    Spacer()
                    Slider(value: $green, in: 0...255, step: 1)
                    Spacer()
                    Slider(value: $blue, in: 0...255, step: 1)
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
            Spacer()
        }
        .padding()
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") { }
            }
        }
    }
}

struct GroupEditView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationView {
                GroupEditView()
            }
            Divider()
            NavigationView {
                GroupEditView(ShowGroup(id: 0, name: "Stargate", icon: icon, color: ShowColor(r: 22, g: 75, b: 123)))
            }
        }
    }

    static let icon = "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"
}
