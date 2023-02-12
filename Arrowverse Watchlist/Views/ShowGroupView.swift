//
//  ShowGroupView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 04/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowGroupView: View {
    @ObservedObject var group: ShowGroupDB

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(group.color))
                .frame(height: 100)

//            if let image = group.image {
//                HStack {
//                    Image(uiImage: image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: 65, maxHeight: 65)
//                    Spacer()
//                }
//                .padding()
//            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(group.name)
                        .font(.title)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
}
