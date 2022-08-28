//
//  ShowDataStore.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import Foundation
import Combine
import TVDBKit
import CoreData

class ShowDataStore: ObservableObject {
    static var shared = ShowDataStore()
    private var persistenceController = PersistenceController.shared

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSaveContext),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )

        if
            let data = UserDefaults.standard.data(forKey: "tracked_shows"),
            let shows = try? JSONDecoder().decode([Show].self, from: data)
        {
            trackedShows = Set(shows)
        } else {
            let shows: [Show] = [
                .Arrow, .Constantine, .Flash, .Legends,
                .Supergirl, .Vixen, .BlackLightning, .Batwoman,
                .Titans, .DoomPatrol, .Stargirl, .Superman
            ]
            trackedShows = Set(shows)
            UserDefaults.standard
                .set(try? JSONEncoder().encode(shows), forKey: "tracked_shows")
        }

        loadEpisodes()
    }

    @Published var requestsInProgress = 0
    @Published var episodes = [WatchableEpisode]()
    @Published var latestEpisodes = [WatchableEpisode]()

    @Published var trackedShows = Set<Show>([
        .Arrow, .Constantine, .Flash, .Legends,
        .Supergirl, .Vixen, .BlackLightning, .Batwoman,
        .Titans, .DoomPatrol, .Stargirl, .Superman
    ])

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }

    func fetch() {
        for show in Show.allCases {
            requestsInProgress += 1
            TVDB.Convenience.getEpisodes(ofShowWithId: show.tvdbId) { result in
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
        let request = NSFetchRequest<WatchableEpisode>(entityName: "WatchableEpisode")
        request.predicate = NSPredicate(format: "rawShow IN %@", trackedShows.map({ $0.rawValue }))

        guard let results = try? persistenceController.container.viewContext.fetch(request) else { return }

        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
            episodes = results
                .sorted(by: { ($0.airDate, $0.episodeNumber) < ($1.airDate, $1.episodeNumber) })
        }

        var latest = [WatchableEpisode]()
        for show in trackedShows {
            if let episode = episodes
                .filter({ $0.show == show })
                .filter({ !$0.watched })
                .sorted(by: { ($0.airDate, $0.episodeNumber) < ($1.airDate, $1.episodeNumber) })
                .first
            {
                latest.append(episode)
            }
        }
        latestEpisodes = latest.sorted(by: { ($0.airDate, $0.episodeNumber) < ($1.airDate, $1.episodeNumber) })
    }

    func loadEpisodes() {
        let request = NSFetchRequest<WatchableEpisode>(entityName: "WatchableEpisode")
        request.predicate = NSPredicate(format: "rawShow IN %@", trackedShows.map({ $0.rawValue }))
        if let results = try? persistenceController.container.viewContext.fetch(request) {
            episodes = results
                .sorted(by: { ($0.airDate, $0.episodeNumber) < ($1.airDate, $1.episodeNumber) })
            var latest = [WatchableEpisode]()
            for show in trackedShows {
                if let episode = episodes
                    .filter({ $0.show == show })
                    .filter({ !$0.watched })
                    .sorted(by: { ($0.airDate, $0.episodeNumber) < ($1.airDate, $1.episodeNumber) })
                    .first
                {
                    latest.append(episode)
                }
            }
            latestEpisodes = latest.sorted(by: { ($0.airDate, $0.episodeNumber) < ($1.airDate, $1.episodeNumber) })
        }
    }

    func insertIntoDB(_ episodes: [Season.Episode], _ show: Show) {
        persistenceController.container.performBackgroundTask { context in
            episodes.forEach { episode in
                let request = NSFetchRequest<WatchableEpisode>(entityName: "WatchableEpisode")
                request.predicate = NSPredicate(format: "id == %i", episode.id)
                if let results = try? context.fetch(request) {
                    if results.isEmpty {
                        let wEpisode = WatchableEpisode(context: context)
                        wEpisode.id = Int64(episode.id)
                        wEpisode.name = episode.name
                        wEpisode.airDate = episode.airDate!
                        wEpisode.show = show
                        wEpisode.episodeNumber = Int64(episode.episodeNumber)
                        wEpisode.seasonNumber = Int64(episode.seasonNumber)
                        context.insert(wEpisode)
                    } else if let result = results.first {
                        if result.name != episode.name {
                            result.name = episode.name
                        }
                    }
                }
            }
            do {
                try context.save()
            } catch {
                print("context save error")
    //            print("[ERROR] There was a problem saving episodes: \(error)")
            }
        }
    }

    func toggleWatchedStatus(for episode: WatchableEpisode) {
        let context = persistenceController.container.viewContext
        episodes.first(where: { $0 == episode })?.watched.toggle()
        do {
            try context.save()
        } catch {
            print("[ERROR] Unable to save watched state for episode with id \(episode.id)")
        }
        print("Watched state for episode \(episode.name): \(episode.watched)")
    }
}
