//
//  EpisodeView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import VisualEffects

struct EpisodeView: View {
    @ObservedObject var episode: Episode

    var body: some View {
        HStack {
            if let imageData = episode.show.imageData, let image = Image(imageData) {
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
                Text(episode.name)
                    .fontWeight(.bold)
                HStack {
                    Text(episode.show.name)
                    Text("\(episode.seasonNumber)x\(episode.episodeNumber)")
                    Text("-")
                    Text(Utils.dateFormatter.string(from: episode.airDate))
                }
                .font(.caption)
            }
            .foregroundColor(.white)

            Spacer()

            if episode.watched {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .padding(.trailing)
            }
        }
        .background(imageBackground(data: episode.show.imageData))
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

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EpisodeView(episode: PersistenceController.episode)
            List {
                ForEach(0..<10, id: \.self) { _ in
                    EpisodeView(episode: PersistenceController.episode)
                }
            }
        }
    }
}
