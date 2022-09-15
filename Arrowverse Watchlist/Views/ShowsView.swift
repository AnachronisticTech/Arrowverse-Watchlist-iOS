//
//  ShowsView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 27/08/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowsView: View {
    @State private var isInEditMode = false

    let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    let columns: [GridItem] = [GridItem(), GridItem()]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    if isInEditMode || config.groupings.isEmpty {
                        NavigationLink {
                            GroupEditView()
                        } label: {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("New Group")
                                        .font(.title2)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.blue)
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                .padding([.horizontal, .bottom])
                            }
                            .frame(height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(UIColor.systemGray5))
                            )
                        }
                        .transition(.slide)
                    }

                    ForEach(config.groupings) { group in
                        NavigationLink {
                            if isInEditMode {
                                GroupEditView(group)
                            } else {
                                GroupMainView(groupManager: GroupManager(config, group.id))
                                    .navigationTitle(group.name)
                            }
                        } label: {
                            ShowGroupView(group: group)
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isInEditMode.toggle()
                        }
                    } label: {
                        Image(systemName: "pencil.circle\(isInEditMode ? ".fill" : "")")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsView()
    }
}
