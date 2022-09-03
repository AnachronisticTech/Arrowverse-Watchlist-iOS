//
//  ShowFilterView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowFilterView: View {
    @StateObject var groupManager: GroupManager

    var body: some View {
        VStack {
            Text("Choose shows to track")
                .font(.title)
                .padding([.top, .horizontal])
            ScrollView {
                LazyVStack {
                    ForEach(groupManager.shows) { show in
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
                        .background(groupManager.trackedShows.contains(show) ? Color(show.color.cgColor) : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding([.leading, .bottom, .trailing], 5)
                        .onTapGesture {
                            groupManager.toggleTrackedStatus(for: show)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ShowFilterList_Previews: PreviewProvider {
    static let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    static var previews: some View {
        ShowFilterView(groupManager: GroupManager(config, 0))
        ShowFilterView(groupManager: GroupManager(config, 1))
        ShowFilterView(groupManager: GroupManager(config, 2))
    }
}
