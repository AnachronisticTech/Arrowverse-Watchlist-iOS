//
//  ImageExtensions.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 14/02/2023.
//  Copyright © 2023 Daniel Marriner. All rights reserved.
//

import SwiftUI
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

extension Image {
    init?(_ data: Data) {
        #if os(macOS)
        guard let image = NSImage(data: data) else { return nil }
        self.init(nsImage: image)
        #elseif os(iOS)
        guard let image = UIImage(data: data) else { return nil }
        self.init(uiImage: image)
        #endif
    }
}
