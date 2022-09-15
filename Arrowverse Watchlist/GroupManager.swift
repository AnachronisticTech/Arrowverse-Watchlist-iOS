//
//  GroupManager.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import Foundation
import Combine
import CoreData
import TheMovieDBKit

class GroupManager: ObservableObject {
    private static var persistenceController = PersistenceController.shared
    private let groupId: Int

    let shows: [Show]
    @Published public private(set) var trackedShows = Set<Show>()

    @Published public private(set) var isRequestInProgress = false
    private var requestsInProgress = 0 {
        didSet {
            isRequestInProgress = requestsInProgress > 0
        }
    }

    init(_ config: Config, _ groupId: Int) {
        self.groupId = groupId
        shows = config.shows.filter { $0.groupId == groupId }

        if
            let data = UserDefaults.standard.data(forKey: "tracked_show_ids_\(groupId)"),
            let showIds = try? JSONDecoder().decode([Int].self, from: data)
        {
            trackedShows = Set(shows.filter { showIds.contains($0.id) })
        } else {
            trackedShows = Set(shows)
            UserDefaults.standard
                .set(try? JSONEncoder().encode(shows.map({ $0.id })), forKey: "tracked_show_ids_\(groupId)")
        }
    }

    func show(for episode: WatchableEpisode) -> Show? {
        shows.first(where: { $0.id == episode.showId })
    }

    func fetch(into context: NSManagedObjectContext) {
        for show in shows {
            requestsInProgress += 1
            TheMovieDB.Convenience.getEpisodes(ofShow: show.id) { result in
                switch result {
                    case .failure(let error):
                        print(error)
                        if case .seasonDecodingError(_, let episodes) = error {
                            self.insert(episodes, from: show, into: context)
                        }
                    case .success(let episodes):
                        self.insert(episodes, from: show, into: context)
                }
                DispatchQueue.main.async {
                    self.requestsInProgress -= 1
                }
            }
        }
    }

    private func insert(_ episodes: [Season.Episode], from show: Show, into c: NSManagedObjectContext) {
        GroupManager.persistenceController.container.performBackgroundTask { context in
            for episode in episodes {
                let request = NSFetchRequest<WatchableEpisode>(entityName: "WatchableEpisode")
                request.predicate = NSPredicate(format: "id == %i", episode.id)
                if let results = try? context.fetch(request) {
                    if results.isEmpty {
                        let wEpisode = WatchableEpisode(context: context)
                        wEpisode.id = Int64(episode.id)
                        wEpisode.name = episode.name
                        wEpisode.airDate = episode.airDate!
                        wEpisode.showId = Int(show.id)
                        wEpisode.episodeNumber = Int64(episode.episodeNumber)
                        wEpisode.seasonNumber = Int64(episode.seasonNumber)
                        context.insert(wEpisode)
                    } else if let result = results.first {
                        result.showId = Int(show.id)
                        if result.name != episode.name {
                            result.name = episode.name
                        }
                    }
                }
            }

            do {
                try context.save()
            } catch {
//                print("context save error")
                print("[ERROR] There was a problem saving episodes: \(error)")
            }
        }
    }

    func toggleTrackedStatus(for show: Show) {
        if trackedShows.contains(show) {
            trackedShows.remove(show)
        } else {
            trackedShows.insert(show)
        }

        UserDefaults.standard
            .set(try? JSONEncoder().encode(trackedShows.map { $0.id }), forKey: "tracked_show_ids_\(groupId)")
    }
}
