//
//  CoreDataFunctions.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 14/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit
import CoreData
    
func fetchAllEpisodes() -> [(Episode, Bool)] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEpisode")
    
    let results: [NSManagedObject]

    do {
        results = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        results = []
        print("Could not fetch. \(error)")
    }
    
    return results.map {
        let episode = Episode(
            $0.value(forKey: "show") as! String,
            $0.value(forKey: "identifier") as! String,
            $0.value(forKey: "title") as! String,
            $0.value(forKey: "aired") as! Date
        )
        let watched = $0.value(forKey: "watched") as! Bool
        return (episode, watched)
    }
}

func fetchEpisode(withID identifier: String) -> (String, Bool, Date)? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEpisode")
    fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
    
    let results: [NSManagedObject]

    do {
        results = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        results = []
        print("Could not fetch \(identifier). \(error)")
    }
    
    if let episode = results.first, let watched = episode.value(forKey: "watched") as? Bool, let aired = episode.value(forKey: "aired") as? Date {
        return (identifier, watched, aired)
    }
    return nil
}

func updateEpisode(withID identifier: String, as watched: Bool) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEpisode")
    fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
    
    do {
        let objects = try managedContext.fetch(fetchRequest)
        if objects.count == 1, let object = objects.first {
            object.setValue(watched, forKey: "watched")
        }
        try managedContext.save()
    } catch let error as NSError {
        print("Could not update and save. \(error)")
    }
}

func episodeExists(with identifier: String) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEpisode")
    fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
    
    let results: [NSManagedObject]

    do {
        results = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        results = []
        print("Could not fetch \(identifier). \(error)")
    }
    
    return results.count > 0
}

func deleteAll() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDEpisode")
    let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        try managedContext.execute(batchDelete)
        print("All records deleted")
    } catch let error as NSError {
        print("Could not delete. \(error)")
    }
}

