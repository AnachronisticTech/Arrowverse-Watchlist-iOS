//
//  Episode.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 14/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit
import CoreData

struct Episode: CustomStringConvertible {
    init(_ show: Show, _ season: Int, _ number: Int, _ title: String, _ aired: Date) {
        self.show = show
        self.id = "S\(season < 10 ? "0" : "")\(season)E\(number < 10 ? "0" : "")\(number)"
        self.title = title
        self.aired = aired
    }
    
    init(_ show: String, _ identifier: String, _ title: String, _ aired: Date) {
        self.show = Show(rawValue: show)!
        self.id = String(identifier.dropFirst(4))
        self.title = title
        self.aired = aired
    }
    
    let show: Show
    let id: String
    let title: String
    let aired: Date
    
    var identifier: String {
        return "\(show.shortName)-\(id)"
    }
    
    var description: String {
        return "\(show.shortName) \(id): \(title), \(aired)"
    }
    
    func save(as watched: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDEpisode", in: managedContext)!
        let episode = NSManagedObject(entity: entity, insertInto: managedContext)
        episode.setValue(identifier, forKey: "identifier")
        episode.setValue(watched, forKey: "watched")
        episode.setValue(aired, forKey: "aired")
        episode.setValue(show.rawValue, forKey: "show")
        episode.setValue(title, forKey: "title")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
}
