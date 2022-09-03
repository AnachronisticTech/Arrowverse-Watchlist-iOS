//
//  WatchableEpisode.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 23/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//
//

import Foundation
import CoreData

@objc(WatchableEpisode)
public class WatchableEpisode: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchableEpisode> {
        return NSFetchRequest<WatchableEpisode>(entityName: "WatchableEpisode")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var airDate: Date
    @NSManaged public var rawShow: String
    @NSManaged public var watched: Bool
    @NSManaged public var episodeNumber: Int64
    @NSManaged public var seasonNumber: Int64
    @NSManaged public var showId: Int

    public var show: Show {
        get { Show(rawValue: rawShow)! }
        set { rawShow = newValue.rawValue }
    }
}
