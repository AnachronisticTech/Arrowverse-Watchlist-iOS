//
//  ShowGroupView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 04/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI
import VisualEffects

struct ShowGroupView: View {
    private var group: SeriesCollection
    private var seriesRequest: FetchRequest<Series>
    private var series: FetchedResults<Series> {
        seriesRequest.wrappedValue
    }
    private var episodesRequest: FetchRequest<Episode>
    private var episodes: [Episode] {
        episodesRequest
            .wrappedValue
            .filter { $0.show.isTracking }
    }
    private var nextEpisode: Episode? {
        episodes
            .filter { !$0.watched }
            .sorted(by: Utils.episodeSorting)
            .first
    }

    private var trackedSeriesLabel: String {
        var text = "\(series.count) Series"
        let trackedCount = series.filter({ $0.isTracking }).count
        if trackedCount < series.count {
            text += " (\(trackedCount) Tracked)"
        }

        return text
    }

    init(group: SeriesCollection) {
        self.group = group
        seriesRequest = FetchRequest<Series>(fetchRequest: DatabaseManager.getSeries(for: group))
        episodesRequest = FetchRequest<Episode>(fetchRequest: DatabaseManager.getEpisodes(for: group))
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(trackedSeriesLabel)
                    .font(.caption)
                Text("\(episodes.count) Episodes (\(episodes.filter({ $0.watched }).count) Watched)")
                    .font(.caption)

                if let next = nextEpisode {
                    if (next.airDate > Date(timeIntervalSinceNow: 0)) {
                        Text("Coming Soon: \(episodeIdentifier(next))")
                            .padding(.top, 4)
                    } else {
                        Text("Next Up: \(episodeIdentifier(next))")
                            .padding(.top, 4)
                    }
                }
            }
            .foregroundColor(.white)
            .padding()

            Spacer()
        }
        .background(artworkBackground())
        .clipShape(Rectangle())
    }

    @ViewBuilder private func artworkBackground() -> some View {
        HStack(spacing: 0) {
            ForEach(series) { show in
                if let imageData = show.imageData, let image = Image(imageData) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }

        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark) {}
    }

    private func episodeIdentifier(_ episode: Episode) -> String {
        return "\(episode.show.name) S\(episode.seasonNumber)E\(episode.episodeNumber) \(episode.name)"
    }
}

struct ShowGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ShowGroupView(group: PersistenceController.group)
    }
}
