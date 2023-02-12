//
//  UpNextMainView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 22/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct UpNextMainView: View {
    @ObservedObject var group: SeriesCollection

    var body: some View {
        ScrollView {
            UpNextListView(shows: group.shows) { episode in
                EpisodeView(episode: episode)
                    .padding(10)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.leading, .bottom, .trailing], 5)
                    .onTapGesture {
                        DatabaseManager.toggleWatchedStatus(for: episode)
                    }
            }
            .padding(.horizontal)
        }
    }
}

//struct UpNextView_Previews: PreviewProvider {
//    static let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))
//
//    static var previews: some View {
//        UpNextMainView(groupManager: GroupManager(config, 0))
//    }
//}
