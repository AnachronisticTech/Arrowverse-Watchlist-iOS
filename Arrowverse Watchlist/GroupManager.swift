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
import TVDBKit

class GroupManager: ObservableObject {
    private static var persistenceController = PersistenceController.shared

    let groupData: ShowGrouping

    private let shows: [ShowData]
    @Published var episodes = [WatchableEpisode]()
    @Published var latestEpisodes = [WatchableEpisode]()
    @Published var trackedShows = [ShowData]()

    @Published var isRequestInProgress = false
    private var requestsInProgress = 0 {
        didSet {
            isRequestInProgress = requestsInProgress > 0
        }
    }

    init(_ config: Config, _ groupId: Int) {
        groupData = config.groupings.first(where: { $0.id == groupId })!
        shows = config.shows.filter { $0.groupId == groupId }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSaveContext),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )

        if
            let data = UserDefaults.standard.data(forKey: "tracked_show_ids"),
            let showIds = try? JSONDecoder().decode([Int].self, from: data)
        {
            trackedShows = shows.filter { showIds.contains($0.id) }
        } else {
            trackedShows = shows
            UserDefaults.standard
                .set(try? JSONEncoder().encode(shows.map({ $0.id })), forKey: "tracked_show_ids")
        }

        loadEpisodes()
    }

    func show(for episode: WatchableEpisode) -> ShowData? {
        shows.first(where: { $0.id == episode.showId })
    }

    func fetch() {
        for show in shows {
            requestsInProgress += 1
            TVDB.Convenience.getEpisodes(ofShowWithId: show.id) { result in
                switch result {
                    case .failure(let error):
                        print(error)
                        if case .seasonDecodingError(_, let episodes) = error {
                            self.insertIntoDB(episodes, show)
                        }
                    case .success(let episodes):
                        self.insertIntoDB(episodes, show)
                }
                DispatchQueue.main.async {
                    self.requestsInProgress -= 1
                }
            }
        }
    }

    @objc func didSaveContext(_ notification: Notification) {
        let request = WatchableEpisode.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: trackedShows.map({ NSPredicate(format: "showId == %ld", $0.id) }))

        guard let results = try? GroupManager.persistenceController.container.viewContext.fetch(request) else { return }

        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
            episodes = results.sorted(by: Utils.episodeSorting)
        }

        var latest = [WatchableEpisode]()
        for show in trackedShows {
            if let episode = episodes
                .filter({ $0.showId == show.id })
                .filter({ !$0.watched })
                .sorted(by: Utils.episodeSorting)
                .first
            {
                latest.append(episode)
            }
        }

        DispatchQueue.main.async {
            self.latestEpisodes = latest.sorted(by: Utils.episodeSorting)
        }
    }

    func loadEpisodes() {
        let request = WatchableEpisode.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: trackedShows.map({ NSPredicate(format: "showId == %ld", $0.id) }))
        if let results = try? GroupManager.persistenceController.container.viewContext.fetch(request) {
            episodes = results.sorted(by: Utils.episodeSorting)
            var latest = [WatchableEpisode]()
            for show in trackedShows {
                if let episode = episodes
                    .filter({ $0.showId == show.id })
                    .filter({ !$0.watched })
                    .sorted(by: Utils.episodeSorting)
                    .first
                {
                    latest.append(episode)
                }
            }
            latestEpisodes = latest.sorted(by: Utils.episodeSorting)
        }
    }

    func insertIntoDB(_ episodes: [Season.Episode], _ show: ShowData) {
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

    func toggleWatchedStatus(for episode: WatchableEpisode) {
        let context = GroupManager.persistenceController.container.viewContext
        episodes.first(where: { $0 == episode })?.watched.toggle()
        do {
            try context.save()
        } catch {
            print("[ERROR] Unable to save watched state for episode with id \(episode.id): \(error)")
        }
        print("Watched state for episode \(episode.name): \(episode.watched)")
    }
}
