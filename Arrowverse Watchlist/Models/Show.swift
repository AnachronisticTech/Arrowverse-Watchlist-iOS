//
//  Show.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 13/07/2020.
//  Copyright © 2020 Daniel Marriner. All rights reserved.
//

import UIKit

struct Show: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let groupId: Int
    let name: String
    let shortName: String
    let icon: String
    let color: ShowColor

    var image: UIImage? {
        if let data = Data(base64Encoded: icon, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }

        return nil
    }

    static func == (lhs: Show, rhs: Show) -> Bool {
        lhs.id == rhs.id
    }
}
