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

    private var content: (WatchableEpisode) -> Content
    private var request: FetchRequest<WatchableEpisode>
    private var episodes: FetchedResults<WatchableEpisode> {
        request.wrappedValue
    }
    private var latestEpisodes: [WatchableEpisode] {
        episodes
            .chunked(on: \.show)
            .compactMap { id, episodes in episodes.first }
            .sorted(by: Utils.episodeSorting)
    }

    init(
        shows: [ShowDB],
        @ViewBuilder _ content: @escaping (WatchableEpisode) -> Content
    ) {
        self.content = content
        request = FetchRequest<WatchableEpisode>(
            entity: WatchableEpisode.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \WatchableEpisode.show, ascending: true),
                NSSortDescriptor(keyPath: \WatchableEpisode.airDate, ascending: true),
                NSSortDescriptor(keyPath: \WatchableEpisode.name, ascending: true)
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
