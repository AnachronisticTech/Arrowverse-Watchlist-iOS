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
    @ObservedObject var group: SeriesCollection

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("\(group.shows.count) Series (\(group.shows.filter({ $0.isTracking }).count) Tracked)")
                    .font(.caption)
                Text("\(group.shows.flatMap({ $0.episodes }).count) Episodes (\(group.shows.flatMap({ $0.episodes }).filter({ $0.watched }).count) Watched)")
                    .font(.caption)

                if let next = group.nextUp {
                    if (next.airDate > Date(timeIntervalSinceNow: 0)) {
                        Text("Coming Soon: \(next.show.name) S\(next.seasonNumber)E\(next.episodeNumber) \(next.name)")
                            .padding(.top, 4)
                    } else {
                        Text("Next Up: \(next.show.name) S\(next.seasonNumber)E\(next.episodeNumber) \(next.name)")
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
            ForEach(group.shows) { show in
                if let imageData = show.imageData, let image = Image(imageData) {
                    image.resizable()
                    .aspectRatio(contentMode: .fill)
                }
            }
        }

        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark) {}
    }
}

struct ShowGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ShowGroupView(group: PersistenceController.group)
    }
}
