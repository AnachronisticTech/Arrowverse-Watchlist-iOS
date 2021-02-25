//
//  ViewController.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit
import CoreData
import SwiftSoup

class ListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var listView: UITableView!
    var episodes = [Episode]()
    var library: [Show: [Episode]] = [
        .Arrow: [], .Constantine: [], .Flash: [], .Legends: [],
        .Supergirl: [], .Vixen: [], .BlackLightning: [], .Batwoman: [],
        .Titans: [], .DoomPatrol: [], .Stargirl: [], .Superman: []
    ] {
        didSet {
            var shouldUpdateList = false
            for episode in library.flatMap({ $0.value }) {
                DispatchQueue.main.sync {
                    if !episodeExists(with: episode.identifier) {
                        episode.save(as: false)
                        shouldUpdateList = true
                    }
                }
            }
            if shouldUpdateList {
                DispatchQueue.main.async {
                    self.episodes = fetchAllEpisodes().map({ $0.0 }).filter({ State.shows.contains($0.show) }).sorted(by: { ($0.aired) < ($1.aired) })
                    self.listView.reloadData()
                }
            }
        }
    }
    
    func getEpisodeList(for show: Show) {
        let task = URLSession.shared.dataTask(with: show.url) { data, response, error in
            if let data = data, let text = String(data: data, encoding: .utf8), let doc = try? SwiftSoup.parse(text) {
                if let tables = try? doc.select("table\(show.isFromWikipedia ? ".wikiepisodetable" : "")").array() {
                    var season = 0
                    var episodes = [Episode]()
                    for table in tables {
                        let table_name = try? table.text().lowercased()
                        if table_name?.contains("series overview") ?? false { continue }
                        season += 1
                        
                        if let rows = try? table.select("tr").array().dropFirst() {
                            var episodeName = ""
                            for row in rows {
                                if let cells = try? row.select("td").array() {
                                    var details = cells.map { try! $0.text().replacingOccurrences(of: "\"", with: "") }
                                    if [.DoomPatrol, .Stargirl].contains(show), details.count <= 1 { continue }
                                    if show == .DoomPatrol, details.count < 4 { continue }
                                    var episodeNumber = Int(details[show.isFromWikipedia ? 0 : 1]) ?? 0
                                    if show == .Stargirl {
                                        if details.count == 5 { episodeName = details[0] }
                                        else { details.insert("\(episodeName), Part II", at: 0) }
                                        episodeNumber = Int(String(details[4].dropFirst(7))) ?? 0
                                    }
                                    if [.Constantine, .Stargirl].contains(show) { details.insert("", at: 0) }
                                    formatter.dateFormat = "MMMM dd, yyyy\(show.isFromWikipedia ? " (yyyy-mm-dd)" : "")"
                                    guard let date = formatter.date(from: show.isFromWikipedia ? details[4] : details.last!) else { continue }
                                    let components = calendar.dateComponents(in: timezone, from: date)
                                    let episode = Episode(
                                        show,
                                        season,
                                        episodeNumber,
                                        details[show.isFromWikipedia ? 1 : 2],
                                        calendar.date(from: components)!
                                    )
                                    episodes.append(episode)
                                }
                            }
                        }
                    }
                    self.library[show]! = episodes
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// DEBUG
//        deleteAll()
        
        listView.delegate = self
        listView.dataSource = self
        listView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "episode")
        
        if let str = UserDefaults.standard.object(forKey: "shows") as? [String] {
            var shows = Set<Show>()
            for show in str {
                shows.insert(Show(rawValue: show)!)
            }
            State.shows = shows
        }

        episodes = fetchAllEpisodes().map({ $0.0 }).filter({ State.shows.contains($0.show) }).sorted(by: { ($0.aired) < ($1.aired) })
        DispatchQueue.main.async {
            self.listView.reloadData() // BUG: First visible rows don't render air dates
        }
        
        Show.allCases.forEach { getEpisodeList(for: $0) }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSelect"  || segue.identifier == "ToSummary" {
            segue.destination.popoverPresentationController?.delegate = self
        }
    }

}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episode = episodes[indexPath.row]
        let cell: ListViewCell = tableView.dequeueReusableCell(withIdentifier: "episode") as! ListViewCell
        cell.title.text = episode.title
        formatter.dateFormat = "MMMM dd, yyyy"
        cell.detail.text = "\(episode.show.name) \(episode.id) - \(formatter.string(from: episode.aired))"
        cell.icon.image = episode.show.icon
        if let local = fetchEpisode(withID: episode.identifier) {
            cell.contentView.backgroundColor = local.1 ? UIColor.lightGray : episode.show.color
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        if let local = fetchEpisode(withID: episode.identifier) {
            updateEpisode(withID: episode.identifier, as: !local.1)
            let cell = tableView.cellForRow(at: indexPath) as! ListViewCell
            cell.contentView.backgroundColor = !local.1 ? UIColor.lightGray : episode.show.color
        }
    }
    
}

extension ListViewController: UIPopoverPresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if State.shouldChange {
            episodes = fetchAllEpisodes().map({ $0.0 }).filter({ State.shows.contains($0.show) }).sorted(by: { ($0.aired) < ($1.aired) })
            DispatchQueue.main.async {
                self.listView.reloadData()
            }
        }
        State.shouldChange = false
    }
    
}
