//
//  Utils.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import Foundation
import TheMovieDBKit
import ATCommon

enum Utils {
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public static let logger: Logger = LoggerBuilder
        .createLogger("Watchlist", from: ConsoleLogger())
        .build()

    private static var imageDataCache = [String: Data]()

    public static func episodeSorting(_ e1: Episode, _ e2: Episode) -> Bool {
        (e1.airDate, e1.episodeNumber) < (e2.airDate, e2.episodeNumber)
    }

    public static func imageData(
        for path: String,
        completion: @escaping (Data?) -> ()
    ) {
        if let data = imageDataCache.first(where: { $0.key == path }) {
            completion(data.value)
        } else {
            TheMovieDB.Images.get(from: path) { result in
                switch result {
                    case .success(let data):
                        imageDataCache[path] = data
                        completion(data)
                    case .failure:
                        completion(nil)
                }
            }
        }
    }
}
