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

    var body: some View {
        ScrollView {
            ForEach(config.groupings) { group in
                VStack {
                    HStack {
                        if let image = group.image {
                            HStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 65, maxHeight: 65)
                            }
                            .frame(width: 65, height: 65, alignment: .center)
                            .padding(10)
                        }

                        Text(group.name)
                            .font(.title)
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .background(Color(.sRGB, red: Double(group.color.r)/255.0, green: Double(group.color.g)/255.0, blue: Double(group.color.b)/255.0, opacity: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.leading, .bottom, .trailing], 5)

                    ForEach(config.shows.filter({ $0.groupId == group.id })) { show in
                        HStack {
                            if let image = show.image {
                                HStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 65, maxHeight: 65)
                                }
                                .frame(width: 65, height: 65, alignment: .center)
                                .padding(10)
                            }

                            Text(show.name)
                                .font(.title)
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .background(Color(.sRGB, red: Double(show.color.r)/255.0, green: Double(show.color.g)/255.0, blue: Double(show.color.b)/255.0, opacity: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding([.leading, .bottom, .trailing], 5)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsView()
    }
}
