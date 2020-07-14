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
        }
    }
    
    var color: CGColor {
        switch self {
        case .Arrow: return UIColor(named: "arrow")!.cgColor
            case .Constantine: return UIColor(named: "constantine")!.cgColor
            case .Flash: return UIColor(named: "flash")!.cgColor
            case .Legends: return UIColor(named: "legends")!.cgColor
            case .Supergirl: return UIColor(named: "supergirl")!.cgColor
            case .Vixen: return UIColor(named: "vixen")!.cgColor
            case .BlackLightning: return UIColor(named: "blackLightning")!.cgColor
            case .Batwoman: return UIColor(named: "batwoman")!.cgColor
        }
    }
    
    var icon: UIImage {
        switch self {
        case .Arrow: return UIImage(named: "arrow")!
        case .Constantine: return UIImage(named: "constantine")!
        case .Flash: return UIImage(named: "flash")!
        case .Legends: return UIImage(named: "legends")!
        case .Supergirl: return UIImage(named: "supergirl")!
        case .Vixen: return UIImage(named: "vixen")!
        case .BlackLightning: return UIImage(named: "blackLightning")!
        case .Batwoman: return UIImage(named: "batwoman")!
        }
    }
    
    private var baseURL: String {
        switch self {
            case .BlackLightning: return "https://en.wikipedia.org/wiki/"
            default: return "https://arrow.fandom.com/wiki/"
        }
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
        }
    }
    
    var url: URL {
        return URL(string: "\(self.baseURL)\(self.episodeListURL)")!
    }
    
    var isFromWikipedia: Bool {
        switch self {
            case .BlackLightning: return true
            default: return false
        }
    }
}
