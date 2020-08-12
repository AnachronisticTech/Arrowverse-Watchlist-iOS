//
//  Show.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit

enum Show: String, CaseIterable {
    case Arrow, Constantine, Flash, Legends
    case Supergirl, Vixen, BlackLightning, Batwoman
    case Titans, DoomPatrol, Stargirl
    
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
        }
    }
    
    var color: CGColor {
        return UIColor(named: constantName)!.cgColor
    }
    
    var icon: UIImage {
        return UIImage(named: constantName)!
    }
    
    private var baseURL: String {
        return isFromWikipedia ? "https://en.wikipedia.org/wiki/" : "https://arrow.fandom.com/wiki/"
    }
    
    private var episodeListURL: String {
        switch self {
            case .Arrow: return "List_of_Arrow_episodes"
            case .Constantine: return "List_of_Constantine_episodes"
            case .Flash: return "List_of_The_Flash_(The_CW)_episodes"
            case .Legends: return "List_of_DC's_Legends_of_Tomorrow_episodes"
            case .Supergirl: return "List_of_Supergirl_episodes"
            case .Vixen: return "List_of_Vixen_episodes"
            case .BlackLightning: return "List_of_Black_Lightning_episodes"
            case .Batwoman: return "List_of_Batwoman_episodes"
            case .Titans: return "Titans_(2018_TV_series)"
            case .DoomPatrol: return "Doom_Patrol_(TV_series)"
            case .Stargirl: return "Stargirl_(TV_series)"
        }
    }
    
    var url: URL {
        return URL(string: "\(baseURL)\(episodeListURL)")!
    }
    
    var isFromWikipedia: Bool {
        let shows: [Show] = [.BlackLightning, .Titans, .DoomPatrol, .Stargirl]
        return shows.contains(self)
    }
}
