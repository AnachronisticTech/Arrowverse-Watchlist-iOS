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
    @NSManaged var isCreated: Bool

    @NSManaged private var pShows: NSSet
}
