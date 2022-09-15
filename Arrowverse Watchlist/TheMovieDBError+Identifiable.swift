//
//  TVDBError+Identifiable.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import TheMovieDBKit

extension TheMovieDBError: Identifiable {
    public var id: Int {
        switch self {
            case .bearerTokenNotSetError: return 0
            case .transportError: return 1
            case .serverError: return 2
            case .emptyData: return 3
            case .decodingError: return 4
            case .seasonDecodingError: return 5
            case .malformedInput: return 6
        }
    }
}
