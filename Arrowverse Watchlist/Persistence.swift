//
//  Persistence.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 18/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let seriesCollection = SeriesCollection(context: viewContext)
        seriesCollection.name = "Stargate"
        seriesCollection.isCreated = true

        let series = Series(context: viewContext)
        series.name = "Stargate SG-1"
        series.group = seriesCollection

        let episode = Episode(context: viewContext)
        episode.name = "Children of the Gods"
        episode.show = series
        episode.seasonNumber = 1
        episode.episodeNumber = 1
        episode.airDate = Date(timeIntervalSinceNow: 0)

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Arrowverse_Watchlist")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.persistentStoreDescriptions.forEach {
            $0.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension PersistenceController {
    static var group: SeriesCollection {
        let seriesCollection = SeriesCollection(context: PersistenceController.preview.container.viewContext)
        seriesCollection.name = "Stargate"
        seriesCollection.imageData = UIImage.sampleData
        return seriesCollection
    }

    static var series: Series {
        let series = Series(context: PersistenceController.preview.container.viewContext)
        series.name = "Stargate SG-1"
        series.imageData = UIImage.sampleData
        series.group = group
        return series
    }

    static var episode: Episode {
        let episode = Episode(context: PersistenceController.preview.container.viewContext)
        episode.name = "Children of the Gods"
        episode.show = series
        episode.seasonNumber = 1
        episode.episodeNumber = 1
        episode.airDate = Date(timeIntervalSinceNow: 0)
        return episode
    }
}
