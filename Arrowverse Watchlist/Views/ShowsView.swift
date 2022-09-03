//
//  ShowsView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 27/08/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    let columns: [GridItem] = [GridItem(), GridItem()]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(config.groupings) { group in
                        NavigationLink {
                            EpisodeListView(groupManager: GroupManager(config, group.id))
                        } label: {
                            viewFor(group)
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .navigationTitle("Groups")
        }
        .navigationViewStyle(.stack)
    }

    func viewFor(_ group: ShowGroup) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(group.color.cgColor))
                .frame(height: 100)

                    if let image = group.image {
                        HStack {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 65, maxHeight: 65)
                            Spacer()
                        }
                        .padding()
                    }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(group.name)
                        .font(.title)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
}

struct ShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsView()
    }
}
