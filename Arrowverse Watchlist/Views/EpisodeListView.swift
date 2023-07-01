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

    private var content: (Episode) -> Content
    private var request: FetchRequest<Episode>
    private var episodes: FetchedResults<Episode> {
        request.wrappedValue
    }

    init(
        shows: [Series],
        @ViewBuilder _ content: @escaping (Episode) -> Content
    ) {
        self.content = content
        request = FetchRequest<Episode>(
            entity: Episode.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Episode.airDate, ascending: true),
                NSSortDescriptor(keyPath: \Episode.episodeNumber, ascending: true)
            ],
            predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: shows
                    .map { NSPredicate(format: "show == %@", $0) }
            )
        )
    }

    var body: some View {
        List(episodes, rowContent: content)
            .listStyle(.plain)
//            .id(UUID())
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView(shows: [PersistenceController.series]) { episode in
            EpisodeView(episode: episode)
        }
    }
}
