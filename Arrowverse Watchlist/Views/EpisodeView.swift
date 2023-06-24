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
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial) {}

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
                    HStack {
                        Text(episode.show.name)
                        Text("\(episode.seasonNumber)x\(episode.episodeNumber)")
                        Text("-")
                        Text(Utils.dateFormatter.string(from: episode.airDate))
                    }
                    .font(.caption)
                }
                .foregroundColor(Color(UIColor.label))
                Spacer()

                if episode.watched {
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
        .background(imageBackground(data: episode.show.imageData))
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
