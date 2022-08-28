//
//  UpNextView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 22/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct UpNextView: View {
    @EnvironmentObject var showDataStore: ShowDataStore

    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Up Next")
                    .font(.title)
                    .padding([.top])
                ForEach(showDataStore.latestEpisodes.filter({ $0.airDate < Date(timeIntervalSinceNow: 0) })) { episode in
                    HStack {
                        EpisodeView(episode: episode)
                            .padding(10)
                    }
                    .background(showDataStore.trackedShows.contains(episode.show) ? Color(episode.show.color.cgColor) : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.leading, .bottom, .trailing], 5)
                    .onTapGesture {
                        showDataStore.toggleWatchedStatus(for: episode)
                    }
                }

                Text("Coming Soon")
                    .font(.title)
                    .padding([.top])
                ForEach(showDataStore.latestEpisodes.filter({ $0.airDate > Date(timeIntervalSinceNow: 0) })) { episode in
                    HStack {
                        EpisodeView(episode: episode)
                            .padding(10)
                    }
                    .background(showDataStore.trackedShows.contains(episode.show) ? Color(episode.show.color.cgColor) : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.leading, .bottom, .trailing], 5)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct UpNextView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextView()
            .environmentObject(ShowDataStore.shared)
    }
}
