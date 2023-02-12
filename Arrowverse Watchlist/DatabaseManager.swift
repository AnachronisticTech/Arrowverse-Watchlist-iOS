//
//  DatabaseManager.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 11/02/2023.
//  Copyright © 2023 Daniel Marriner. All rights reserved.
//

import CoreData
import TheMovieDBKit

class DatabaseManager {
    private static let container = PersistenceController.shared.container

    private init() {}

    public static func save(_ searchResult: SeriesSearchResult.SearchResult, into group: ShowGroupDB) {
        let show = ShowDB(context: container.viewContext)
        show.id = Int64(searchResult.id)
        show.name = searchResult.name
        show.airDate = searchResult.firstAirDate
        show.group = group
        if let imagePath = searchResult.posterPath {
            Utils.imageData(for: imagePath) { data in
                show.imageData = data
                do {
                    try container.viewContext.save()
                } catch {
                    print("Failed to save show image data: \(error)")
                }
            }
        }

        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save show: \(error)")
        }
    }

    public static func save(_ episodes: [Season.Episode], into show: ShowDB) {
        container.performBackgroundTask { context in
            guard let fetchedShow = context.object(with: show.objectID) as? ShowDB else {
                print("[ERROR] Could not fetch show \(show) in background context")
                return
            }

            fetchedShow.hasPerformedFirstFetch = true
            let request = WatchableEpisode.fetchRequest()
            for episode in episodes {
                request.predicate = NSPredicate(format: "id == %i", episode.id)
                request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
                    NSPredicate(format: "id == %i", episode.id),
                    NSPredicate(format: "show == %@", fetchedShow)
                ])
                if let results = try? context.fetch(request) {
                    if results.isEmpty {
                        let we = WatchableEpisode(context: context)
                        we.id = Int64(episode.id)
                        we.name = episode.name
                        we.airDate = episode.airDate!
                        we.show = fetchedShow
                        we.episodeNumber = Int64(episode.episodeNumber)
                        we.seasonNumber = Int64(episode.seasonNumber)
                        context.insert(we)
                    } else if let result = results.first {
                        result.show = fetchedShow
                        if result.name != episode.name {
                            result.name = episode.name
                        }
                    }
                }
            }

            do {
                try context.save()
            } catch {
                print("[ERROR] There was a problem saving episodes: \(error)")
            }
        }
    }

    public static func toggleWatchedStatus(for episode: WatchableEpisode) {
        if episode.airDate < Date(timeIntervalSinceNow: 0) {
            episode.watched.toggle()
            do {
                try container.viewContext.save()
            } catch {
                print("[ERROR] Could not save watch state for \(episode). \(error)")
            }
        }
    }

    public static func toggleTrackingStatus(for show: ShowDB) {
        show.isTracking.toggle()
        do {
            try container.viewContext.save()
        } catch {
            print("[ERROR] Could not save tracking state for \(show). \(error)")
        }
    }
}
