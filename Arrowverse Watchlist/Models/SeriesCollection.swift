//
//  SeriesCollection.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import UIKit
import CoreData

@objc(SeriesCollection)
public class SeriesCollection: NSManagedObject, Identifiable {
    @NSManaged var name: String
    @NSManaged var imageData: Data?
    @NSManaged var red: Int16
    @NSManaged var green: Int16
    @NSManaged var blue: Int16

    @NSManaged private var pShows: NSSet
    public var shows: [Series] {
        let set = pShows as? Set<Series> ?? []
        return set
            .sorted { ($0.airDate ?? Date(timeIntervalSince1970: 0), $0.name) < ($1.airDate ?? Date(timeIntervalSince1970: 0), $1.name) }
    }

    public var trackedShows: [Series] { shows.filter({ $0.isTracking }) }

    @NSManaged var isCreated: Bool

    var color: CGColor {
        CGColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
}
