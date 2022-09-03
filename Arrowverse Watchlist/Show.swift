//
//  Show.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit

struct Config: Codable {
    let groupings: [ShowGrouping]
    let shows: [ShowData]
}

struct ShowGrouping: Codable, Identifiable {
    let id: Int
    let name: String
    let icon: String
    let color: ShowColor

    var image: UIImage? {
        if let data = Data(base64Encoded: icon, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }

        return nil
    }
}

struct ShowData: Codable, Identifiable, Equatable {
    let id: Int
    let groupId: Int
    let name: String
    let shortName: String
    let icon: String
    let color: ShowColor

    var image: UIImage? {
        if let data = Data(base64Encoded: icon, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }

        return nil
    }

    static func == (lhs: ShowData, rhs: ShowData) -> Bool {
        lhs.id == rhs.id
    }
}

struct ShowColor: Codable {
    let r: Int
    let g: Int
    let b: Int

    var cgColor: CGColor {
        CGColor(
            red: CGFloat(Double(r)/255.0),
            green: CGFloat(Double(g)/255.0),
            blue: CGFloat(Double(b)/255.0),
            alpha: 1
        )
    }
}

public enum Show: String, CaseIterable, Codable {
    case Arrow, Constantine, Flash, Legends
    case Supergirl, Vixen, BlackLightning, Batwoman
    case Titans, DoomPatrol, Stargirl, Superman

    var name: String {
        switch self {
            case .Arrow: return "Arrow"
            case .Constantine: return "Constantine"
            case .Flash: return "The Flash"
            case .Legends: return "DC's Legends of Tomorrow"
            case .Supergirl: return "Supergirl"
            case .Vixen: return "Vixen"
            case .BlackLightning: return "Black Lightning"
            case .Batwoman: return "Batwoman"
            case .Titans: return "Titans"
            case .DoomPatrol: return "Doom Patrol"
            case .Stargirl: return "Stargirl"
            case .Superman: return "Superman & Lois"
        }
    }

    var shortName: String {
        switch self {
            case .Arrow: return "ARR"
            case .Constantine: return "CON"
            case .Flash: return "FLA"
            case .Legends: return "LoT"
            case .Supergirl: return "SUP"
            case .Vixen: return "VIX"
            case .BlackLightning: return "BLA"
            case .Batwoman: return "BAT"
            case .Titans: return "TTN"
            case .DoomPatrol: return "PAT"
            case .Stargirl: return "STA"
            case .Superman: return "SaL"
        }
    }

    var tvdbId: Int {
        switch self {
            case .Arrow: return 1412
            case .Constantine: return 60743
            case .Flash: return 60735
            case .Legends: return 62643
            case .Supergirl: return 62688
            case .Vixen: return 62125
            case .BlackLightning: return 71663
            case .Batwoman: return 89247
            case .Titans: return 75450
            case .DoomPatrol: return 79501
            case .Stargirl: return 80986
            case .Superman: return 95057
        }
    }

    private var constantName: String {
        switch self {
            case .Arrow: return "arrow"
            case .Constantine: return "constantine"
            case .Flash: return "flash"
            case .Legends: return "legends"
            case .Supergirl: return "supergirl"
            case .Vixen: return "vixen"
            case .BlackLightning: return "blackLightning"
            case .Batwoman: return "batwoman"
            case .Titans: return "titans"
            case .DoomPatrol: return "doomPatrol"
            case .Stargirl: return "stargirl"
            case .Superman: return "superman"
        }
    }

    var color: UIColor {
        return UIColor(named: constantName)!
    }

    var icon: UIImage {
        return UIImage(named: constantName)!
    }
}
