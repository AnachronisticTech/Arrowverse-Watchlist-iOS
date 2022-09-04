//
//  EpisodeListView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 20/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct EpisodeListView<Content: View>: View {
    @Environment(\.managedObjectContext) private var viewContext

    private var content: (WatchableEpisode) -> Content
    private var request: FetchRequest<WatchableEpisode>
    private var episodes: FetchedResults<WatchableEpisode> {
        request.wrappedValue
    }

    init(
        shows: [Show],
        @ViewBuilder _ content: @escaping (WatchableEpisode) -> Content
    ) {
        self.content = content
        request = FetchRequest<WatchableEpisode>(
            entity: WatchableEpisode.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \WatchableEpisode.airDate, ascending: true),
                NSSortDescriptor(keyPath: \WatchableEpisode.name, ascending: true)
            ],
            predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: shows
                    .map { NSPredicate(format: "showId == %ld", $0.id) }
            )
        )
    }

    var body: some View {
        List(episodes, rowContent: content)
            .id(UUID())
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView(shows: []) { episode in
            Text(episode.name)
        }
    }
}
