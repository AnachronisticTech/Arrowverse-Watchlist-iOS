//
//  ShowGroup.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 03/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import UIKit

struct ShowGroup: Codable, Identifiable {
    let id: Int
    let name: String
    let icon: String
    let color: ShowColor

    var image: UIImage? {
        if let data = Data(base64Encoded: icon, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }

        return nil
    }
}
