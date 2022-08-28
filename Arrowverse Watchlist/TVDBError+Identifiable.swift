//
//  TVDBError+Identifiable.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import TVDBKit

extension TVDBError: Identifiable {
    public var id: Int {
        switch self {
            case .bearerTokenNotSetError: return 0
            case .transporError(_): return 1
            case .serverError(_): return 2
            case .emptyData: return 3
            case .decodingError(_): return 4
            case .seasonDecodingError(_, _): return 5
        }
    }
}
