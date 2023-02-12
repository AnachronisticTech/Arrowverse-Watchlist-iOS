//
//  EpisodeView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct EpisodeView: View {
    @ObservedObject var episode: Episode

    var body: some View {
        HStack {
            if let image = episode.show.image {
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
                    Text("\(episode.show.name) \(episode.seasonNumber)x\(episode.episodeNumber) - ") +
                        Text(Utils.dateFormatter.string(from: episode.airDate))
                }
                .font(.caption)
            }
            .foregroundColor(.white)
            Spacer()
        }
        .contentShape(Rectangle())
        .listRowBackground(episode.watched ? Color.gray : Color(episode.show.color))
    }
}
