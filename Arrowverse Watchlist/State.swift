//
//  State.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import Foundation

struct State {
    static var shows: Set<Show> = [
        .Arrow, .Constantine, .Flash, .Legends,
        .Supergirl, .Vixen, .BlackLightning, .Batwoman
    ] {
        willSet {
            shouldChange = false
            if newValue != shows {
                let str = newValue.map { $0.rawValue }
                UserDefaults.standard.set(str, forKey: "shows")
                shouldChange = true
            }
        }
    }
    
    static var shouldChange: Bool = false
}
