//
//  Show.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit
import CoreData

@objc(ShowDB)
public class ShowDB: NSManagedObject, Identifiable {
    @NSManaged public var id: Int64
    @NSManaged var name: String
    @NSManaged var airDate: Date?
    @NSManaged var imageData: Data?
    @NSManaged var red: Int16
    @NSManaged var green: Int16
    @NSManaged var blue: Int16
    @NSManaged var hasPerformedFirstFetch: Bool
    @NSManaged var isTracking: Bool

    @NSManaged var group: ShowGroupDB

    @NSManaged private var pEpisodes: NSSet
    public var episodes: [WatchableEpisode] {
        let set = pEpisodes as? Set<WatchableEpisode> ?? []
        return set.sorted(by: Utils.episodeSorting)
    }

    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }

        return nil
    }

    var color: CGColor {
        CGColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
}
