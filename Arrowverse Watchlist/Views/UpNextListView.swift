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
    private var latestEpisodes: [Episode] {
        request
            .wrappedValue
            .chunked(on: \.show)
            .filter { (show, _) in show.isTracking }
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
                NSSortDescriptor(keyPath: \Episode.episodeNumber, ascending: true),
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
                ]
            )
        )
    }

    var body: some View {
        List {
            Section(header: titleView("Up Next")) {
                ForEach(latestEpisodes.filter({ $0.airDate < Date(timeIntervalSinceNow: 0) })) { episode in
                    content(episode)
                }
            }

            if latestEpisodes.filter({ $0.airDate > Date(timeIntervalSinceNow: 0) }).count > 0 {
                Section(header: titleView("Coming Soon")) {
                    ForEach(latestEpisodes.filter({ $0.airDate > Date(timeIntervalSinceNow: 0) })) { episode in
                        content(episode)
                    }
                }
            }
        }
        .listStyle(.plain)
        .listRowInsets(.none)
    }

    @ViewBuilder private func titleView(_ text: String) -> some View {
        HStack {
            Spacer()
            Text(text)
                .font(.title)
            Spacer()
        }
        .padding([.top])
    }
}

struct UpNextListView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextListView(shows: PersistenceController.group.shows) { episode in
            EpisodeView(episode: episode)
        }
    }
}
