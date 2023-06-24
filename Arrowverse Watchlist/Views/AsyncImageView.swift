//
//  AsyncImageView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 18/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct AsyncImageView: View {
    let path: String
    let imageFunc: (String, @escaping (Data?) -> ()) -> ()

    @State private var imageData: Data? = nil

    var body: some View {
        Group {
            if let data = imageData, let image = Image(data) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .aspectRatio(0.75, contentMode: .fit)
            }
        }
        .onAppear {
            imageFunc(path) { data in
                imageData = data
            }
        }
    }
}
