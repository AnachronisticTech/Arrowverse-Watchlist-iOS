//
//  Config.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

struct Config: Codable {
    let groupings: [ShowGroup]
    let shows: [Show]
}
