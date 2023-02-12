//
//  Episode.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 23/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Episode)
public class Episode: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var airDate: Date
    @NSManaged public var watched: Bool
    @NSManaged public var episodeNumber: Int64
    @NSManaged public var seasonNumber: Int64

    @NSManaged var show: Series
}
