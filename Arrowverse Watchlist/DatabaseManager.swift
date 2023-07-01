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

    public static func getSeries(for group: SeriesCollection) -> NSFetchRequest<Series> {
        let request = NSFetchRequest<Series>()
        request.entity = Series.entity()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "group == %@", group)
        return request
    }

    public static func getEpisodes(for group: SeriesCollection) -> NSFetchRequest<Episode> {
        let request = NSFetchRequest<Episode>()
        request.entity = Episode.entity()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Episode.show, ascending: true),
            NSSortDescriptor(keyPath: \Episode.airDate, ascending: true),
            NSSortDescriptor(keyPath: \Episode.episodeNumber, ascending: true),
            NSSortDescriptor(keyPath: \Episode.name, ascending: true)
        ]
        request.predicate = NSPredicate(format: "show.group == %@", group)
        return request
    }

    public static func getEpisodes(for series: [Series]) -> NSFetchRequest<Episode> {
        let request = NSFetchRequest<Episode>()
        request.entity = Episode.entity()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Episode.show, ascending: true),
            NSSortDescriptor(keyPath: \Episode.airDate, ascending: true),
            NSSortDescriptor(keyPath: \Episode.episodeNumber, ascending: true),
            NSSortDescriptor(keyPath: \Episode.name, ascending: true)
        ]
        request.predicate = NSCompoundPredicate(
            type: .or,
            subpredicates: series
                .map { NSPredicate(format: "show == %@", $0) }
        )
        return request
    }

    public static func getUpNextEpisodes(for group: SeriesCollection) -> NSFetchRequest<Episode> {
        let request = NSFetchRequest<Episode>()
        request.entity = Episode.entity()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Episode.show, ascending: true),
            NSSortDescriptor(keyPath: \Episode.airDate, ascending: true),
            NSSortDescriptor(keyPath: \Episode.episodeNumber, ascending: true),
            NSSortDescriptor(keyPath: \Episode.name, ascending: true)
        ]
        request.predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [
                NSPredicate(format: "watched == %@", NSNumber(value: false)),
                NSPredicate(format: "show.group == %@", group)
            ]
        )
        return request
    }

    public static func getUpNextEpisodes(for series: [Series]) -> NSFetchRequest<Episode> {
        let request = NSFetchRequest<Episode>()
        request.entity = Episode.entity()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Episode.show, ascending: true),
            NSSortDescriptor(keyPath: \Episode.airDate, ascending: true),
            NSSortDescriptor(keyPath: \Episode.episodeNumber, ascending: true),
            NSSortDescriptor(keyPath: \Episode.name, ascending: true)
        ]
        request.predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [
                NSPredicate(format: "watched == %@", NSNumber(value: false)),
                NSCompoundPredicate(
                    type: .or,
                    subpredicates: series
                        .map { NSPredicate(format: "show == %@", $0) }
                )
            ]
        )
        return request
    }

    public static func save(_ searchResult: SeriesSearchResult.SearchResult, into group: SeriesCollection) {
        let show = Series(context: container.viewContext)
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

    public static func save(_ episodes: [Season.Episode], into show: Series) {
        container.performBackgroundTask { context in
            guard let fetchedShow = context.object(with: show.objectID) as? Series else {
                print("[ERROR] Could not fetch show \(show) in background context")
                return
            }

            fetchedShow.hasPerformedFirstFetch = true
            let request = Episode.fetchRequest()
            for episode in episodes {
                request.predicate = NSPredicate(format: "id == %i", episode.id)
                request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
                    NSPredicate(format: "id == %i", episode.id),
                    NSPredicate(format: "show == %@", fetchedShow)
                ])
                if let results = try? context.fetch(request) {
                    if results.isEmpty {
                        let we = Episode(context: context)
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

    public static func toggleWatchedStatus(for episode: Episode) {
        guard episode.airDate < Date(timeIntervalSinceNow: 0) else { return }
        episode.watched.toggle()
        do {
            try container.viewContext.save()
        } catch {
            print("[ERROR] Could not save watch state for \(episode). \(error)")
        }
    }

    public static func toggleTrackingStatus(for show: Series) {
        show.isTracking.toggle()
        do {
            try container.viewContext.save()
        } catch {
            print("[ERROR] Could not save tracking state for \(show). \(error)")
        }
    }

    public static func delete(_ group: SeriesCollection) {
        container.viewContext.delete(group)

        do {
            try container.viewContext.save()
        } catch {
            print("Could not delete object \(group): \(error)")
        }
    }

    public static func delete(_ show: Series) {
        container.viewContext.delete(show)

        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save show state: \(error)")
        }
    }

    #if DEBUG
    public static func deleteAll() {
        let fetchRequest = Series.fetchRequest()
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(batchDelete)
            try container.viewContext.save()
        } catch {
            print("Could not delete shows with error \(error)")
        }

        let fetchRequest2 = SeriesCollection.fetchRequest()
        let batchDelete2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)

        do {
            try container.viewContext.execute(batchDelete2)
            try container.viewContext.save()
        } catch {
            print("Could not delete showgroups with error \(error)")
        }
    }
    #endif
}
