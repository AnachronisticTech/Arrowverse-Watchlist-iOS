//
//  Series.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import CoreGraphics
import CoreData

@objc(Series)
public class Series: NSManagedObject, Identifiable {
    @NSManaged public var id: Int64
    @NSManaged var name: String
    @NSManaged var airDate: Date?
    @NSManaged var imageData: Data?
    @NSManaged var hasPerformedFirstFetch: Bool
    @NSManaged var isTracking: Bool

    @NSManaged var group: SeriesCollection

    @NSManaged private var pEpisodes: NSSet
    public var episodes: [Episode] {
        let set = pEpisodes as? Set<Episode> ?? []
        return set.sorted(by: Utils.episodeSorting)
    }
}
