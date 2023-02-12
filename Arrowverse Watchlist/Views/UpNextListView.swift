//
//  UpNextListView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 04/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI
import Algorithms

struct UpNextListView<Content: View>: View {
    @Environment(\.managedObjectContext) private var viewContext

    private var content: (Episode) -> Content
    private var request: FetchRequest<Episode>
    private var episodes: FetchedResults<Episode> {
        request.wrappedValue
    }
    private var latestEpisodes: [Episode] {
        episodes
            .chunked(on: \.show)
            .compactMap { id, episodes in episodes.first }
            .sorted(by: Utils.episodeSorting)
    }

    init(
        shows: [Series],
        @ViewBuilder _ content: @escaping (Episode) -> Content
    ) {
        self.content = content
        request = FetchRequest<Episode>(
            entity: Episode.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Episode.show, ascending: true),
                NSSortDescriptor(keyPath: \Episode.airDate, ascending: true),
                NSSortDescriptor(keyPath: \Episode.name, ascending: true)
            ],
            predicate: NSCompoundPredicate(
                type: .and,
                subpredicates: [
                    NSPredicate(format: "watched == %@", NSNumber(value: false)),
                    NSCompoundPredicate(
                        type: .or,
                        subpredicates: shows
                            .map { NSPredicate(format: "show == %@", $0) }
                    )
                ])
        )
    }

    var body: some View {
        LazyVStack {
            Text("Up Next")
                .font(.title)
                .padding([.top])

            ForEach(latestEpisodes.filter({ $0.airDate < Date(timeIntervalSinceNow: 0) })) { episode in
                content(episode)
            }

            Text("Coming Soon")
                .font(.title)
                .padding([.top])

            ForEach(latestEpisodes.filter({ $0.airDate > Date(timeIntervalSinceNow: 0) })) { episode in
                content(episode)
            }
        }
    }
}

struct UpNextListView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextListView(shows: []) { episode in
            Text(episode.name)
        }
    }
}
