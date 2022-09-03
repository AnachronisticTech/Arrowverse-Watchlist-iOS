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
    let show: ShowData?

    init(episode: WatchableEpisode) {
        self.episode = episode
        show = nil
    }

    init(episode: WatchableEpisode, show: ShowData?) {
        self.episode = episode
        self.show = show
    }

    var body: some View {
        HStack {
            if let image = show?.image {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 65, maxHeight: 65)
                }
                .frame(width: 65, height: 65, alignment: .center)
            }

            VStack(alignment: .leading) {
                Text(episode.name)
                HStack {
                    Text("\(show?.name ?? "") \(episode.seasonNumber)x\(episode.episodeNumber) - ") +
                        Text(Utils.dateFormatter.string(from: episode.airDate))
                }
                .font(.caption)
            }
            .foregroundColor(.white)
            Spacer()
        }
        .contentShape(Rectangle())
        .listRowBackground(episode.watched ? Color.gray : show != nil ? Color(show!.color.cgColor) : .black)
    }
}
