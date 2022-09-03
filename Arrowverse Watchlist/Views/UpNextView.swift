//
//  UpNextView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 22/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct UpNextView: View {
    @StateObject var groupManager: GroupManager

    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Up Next")
                    .font(.title)
                    .padding([.top])
                ForEach(groupManager.latestEpisodes.filter({ $0.airDate < Date(timeIntervalSinceNow: 0) })) { episode in
                    HStack {
                        EpisodeView(episode: episode, show: groupManager.show(for: episode)!)
                            .padding(10)
                    }
                    .background(groupManager.trackedShows.contains(groupManager.show(for: episode)!) ? Color(groupManager.show(for: episode)!.color.cgColor) : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.leading, .bottom, .trailing], 5)
                    .onTapGesture {
                        groupManager.toggleWatchedStatus(for: episode)
                    }
                }

                Text("Coming Soon")
                    .font(.title)
                    .padding([.top])
                ForEach(groupManager.latestEpisodes.filter({ $0.airDate > Date(timeIntervalSinceNow: 0) })) { episode in
                    HStack {
                        EpisodeView(episode: episode, show: groupManager.show(for: episode)!)
                            .padding(10)
                    }
                    .background(groupManager.trackedShows.contains(groupManager.show(for: episode)!) ? Color(groupManager.show(for: episode)!.color.cgColor) : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.leading, .bottom, .trailing], 5)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct UpNextView_Previews: PreviewProvider {
    static let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    static var previews: some View {
        UpNextView(groupManager: GroupManager(config, 0))
    }
}
