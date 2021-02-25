//
//  SelectViewController.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    
    var shows: Set<Show> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        listView.register(UINib(nibName: "SelectViewCell", bundle: nil), forCellReuseIdentifier: "button")
        listView.backgroundColor = .clear
        
        shows = State.shows
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        State.shows = shows
    }
}

extension SelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Show.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = Show.allCases[indexPath.row]
        let state = shows.contains(show)
        let cell: SelectViewCell = tableView.dequeueReusableCell(withIdentifier: "button") as! SelectViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        cell.background.backgroundColor = state ? show.color : .lightGray
        cell.background.layer.cornerRadius = 10
        cell.title.text = show.name.uppercased()
        cell.icon.image = show.icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = Show.allCases[indexPath.row]
        if shows.count == 1 && shows.contains(show) { return }
        if shows.contains(show) {
            shows.remove(show)
        } else {
            shows.insert(show)
        }
        let cell = tableView.cellForRow(at: indexPath) as! SelectViewCell
        if shows.contains(show) {
            cell.background.backgroundColor = show.color
        } else {
            cell.background.backgroundColor = .lightGray
        }
    }
    
}
