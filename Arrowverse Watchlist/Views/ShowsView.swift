//
//  ShowsView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 27/08/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowsView: View {
    let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    let columns: [GridItem] = [GridItem(), GridItem()]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(config.groupings) { group in
                        NavigationLink {
                            GroupMainView(groupManager: GroupManager(config, group.id))
                                .navigationTitle(group.name)
                        } label: {
                            ShowGroupView(group: group)
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .navigationTitle("Groups")
        }
        .navigationViewStyle(.stack)
    }
}

struct ShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsView()
    }
}
