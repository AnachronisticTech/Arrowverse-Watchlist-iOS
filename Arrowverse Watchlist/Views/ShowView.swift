//
//  ShowView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 24/06/2023.
//  Copyright © 2023 Daniel Marriner. All rights reserved.
//

import SwiftUI
import VisualEffects

struct ShowView: View {
    @ObservedObject var show: Series

    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial) {}

            HStack {
                if let imageData = show.imageData, let image = Image(imageData) {
                    HStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 65, maxHeight: 65)
                    }
                    .frame(width: 65, height: 65, alignment: .center)
                    .padding([.leading, .top, .bottom], 4)
                }

                VStack(alignment: .leading) {
                    Text(show.name)
                        .font(.title)
                }
                .foregroundColor(Color(UIColor.label))
                Spacer()

                if show.isTracking {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 25, height: 25)
                        .padding(.trailing)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(Color(UIColor.systemBackground))
            )
            .padding(8)
        }
        .contentShape(Rectangle())
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .background(imageBackground(data: show.imageData))
        .clipShape(Rectangle())
    }

    @ViewBuilder private func imageBackground(data: Data?) -> some View {
        if let data = data, let image = Image(data) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            EmptyView()
        }
    }
}

struct ShowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ShowView(show: PersistenceController.series)
            List {
                ForEach(0..<10, id: \.self) { _ in
                    ShowView(show: PersistenceController.series)
                }
            }
        }
    }
}
