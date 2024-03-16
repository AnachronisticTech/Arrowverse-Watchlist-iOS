//
//  PrimaryAppIcon.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 11/03/2024.
//  Copyright © 2024 Daniel Marriner. All rights reserved.
//

import UIKit
import ATiOS

struct PrimaryAppIcon: DefaultAppIcon {
    let id: String = "Primary"
    var description: String = "Default"
    var preview: UIImage = UIImage(named: "AppIcon") ?? UIImage()
}
