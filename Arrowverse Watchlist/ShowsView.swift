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
                        NavigationLink(destination: Text(group.name)) {
                            viewFor(group)
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .navigationTitle("Groups")
        }
    }

    func viewFor(_ group: ShowGrouping) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(
                    Color(
                        .sRGB,
                        red: Double(group.color.r)/255.0,
                        green: Double(group.color.g)/255.0,
                        blue: Double(group.color.b)/255.0,
                        opacity: 1
                    )
                )
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
