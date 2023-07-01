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

    private var episodesRequest: FetchRequest<Episode>
    private var episodes: FetchedResults<Episode> {
        episodesRequest.wrappedValue
    }

    init(show: Series) {
        self.show = show
        episodesRequest = FetchRequest<Episode>(fetchRequest: DatabaseManager.getEpisodes(for: [show]))
    }

    var body: some View {
        HStack(spacing: 0) {
            if let imageData = show.imageData, let image = Image(imageData) {
                HStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 65, maxHeight: 65)
                }
            }

            VStack(alignment: .leading) {
                Text(show.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("\(episodes.count) Episodes (\(episodes.filter({ $0.watched }).count) Watched)")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .padding()

            Spacer()

            if show.isTracking {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .padding(.trailing)
            }
        }
        .background(imageBackground(data: show.imageData))
        .clipShape(Rectangle())
        .listRowInsets(.init())
    }

    @ViewBuilder private func imageBackground(data: Data?) -> some View {
        if let data = data, let image = Image(data) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }

        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark) {}
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
