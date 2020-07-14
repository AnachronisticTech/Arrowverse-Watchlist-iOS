//
//  NextViewController.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 14/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit
import CoreData

class NextViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    
    var shows: Set<Show> = []
    var latest: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        listView.register(UINib(nibName: "NextViewCell", bundle: nil), forCellReuseIdentifier: "button")
        listView.backgroundColor = .clear
        
        shows = State.shows
        let episodes = fetchAllEpisodes()
        for show in shows {
            let (episode, _) = episodes
                .filter({ $0.0.show == show })
                .filter({ !$0.1 })
                .sorted(by: { $0.0.aired < $1.0.aired })
                .first!
            latest.append(episode)
        }
        latest.sort(by: { $0.aired < $1.aired })
    }
}

extension NextViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episode = latest[indexPath.row]
        let cell: NextViewCell = tableView.dequeueReusableCell(withIdentifier: "button") as! NextViewCell
        cell.isUserInteractionEnabled = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        cell.background.layer.cornerRadius = 10
        cell.background.backgroundColor = UIColor(cgColor: episode.show.color)
        cell.title.text = episode.title
        cell.detail.text = "\(episode.show.name) \(episode.id)"
        cell.icon.image = episode.show.icon
        return cell
    }
    
}
