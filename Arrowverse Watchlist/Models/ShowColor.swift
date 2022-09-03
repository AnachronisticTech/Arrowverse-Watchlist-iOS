//
//  ShowColor.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import CoreGraphics

struct ShowColor: Codable, Hashable {
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
