//
//  SeriesCollection.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import CoreGraphics
import CoreData

@objc(SeriesCollection)
public class SeriesCollection: NSManagedObject, Identifiable {
    @NSManaged var name: String
    @NSManaged var imageData: Data?
    @NSManaged private var red: Float
    @NSManaged private var green: Float
    @NSManaged private var blue: Float
    @NSManaged var isCreated: Bool

    @NSManaged private var pShows: NSSet
    public var shows: [Series] {
        let set = pShows as? Set<Series> ?? []
        return set
            .sorted { ($0.airDate ?? Date(timeIntervalSince1970: 0), $0.name) < ($1.airDate ?? Date(timeIntervalSince1970: 0), $1.name) }
    }

    public var trackedShows: [Series] { shows.filter({ $0.isTracking }) }
    public var nextUp: Episode? {
        get {
            return trackedShows
                .flatMap { $0.episodes }
                .filter { !$0.watched }
                .sorted(by: Utils.episodeSorting(_:_:))
                .first
        }
    }

    var color: CGColor {
        get {
            CGColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        }
        set {
            red = Float(newValue.components![0])
            green = Float(newValue.components![1])
            blue = Float(newValue.components![2])
        }
    }
}
