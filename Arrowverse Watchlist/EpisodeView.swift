//
//  EpisodeView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import TVDBKit

struct EpisodeView: View {
    @ObservedObject var episode: WatchableEpisode

    @EnvironmentObject var showDataStore: ShowDataStore

    var body: some View {
        HStack {
            HStack {
                Image(uiImage: episode.show.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 65, maxHeight: 65)
            }
            .frame(width: 65, height: 65, alignment: .center)
            VStack(alignment: .leading) {
                Text(episode.name)
                HStack {
                    Text("\(episode.show.name) \(episode.seasonNumber)x\(episode.episodeNumber) - ") +
                        Text(showDataStore.dateFormatter.string(from: episode.airDate))
                }
                .font(.caption)
            }
            .foregroundColor(.white)
            Spacer()
        }
        .contentShape(Rectangle())
        .listRowBackground(episode.watched ? Color.gray : Color(episode.show.color.cgColor))
    }
}
