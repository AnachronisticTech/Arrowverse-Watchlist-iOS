//
//  UserInterface.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 14/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
}

class SelectViewCell: UITableViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
}

class NextViewCell: SelectViewCell {
    @IBOutlet weak var detail: UILabel!
}
