//
//  Utils.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import Foundation

struct Utils {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static func episodeSorting(_ e1: WatchableEpisode, _ e2: WatchableEpisode) -> Bool {
        (e1.airDate, e1.episodeNumber) < (e2.airDate, e2.episodeNumber)
    }
}
