//
//  UpNextMainView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 22/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct UpNextMainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var groupManager: GroupManager

    var body: some View {
        ScrollView {
            UpNextListView(shows: Array(groupManager.trackedShows)) { episode in
                EpisodeView(episode: episode, show: groupManager.show(for: episode)!)
                    .padding(10)
                    .background(Color(groupManager.show(for: episode)!.color.cgColor))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.leading, .bottom, .trailing], 5)
                    .onTapGesture {
                        if episode.airDate < Date(timeIntervalSinceNow: 0) {
                            episode.watched.toggle()
                            do {
                                try viewContext.save()
                            } catch {
                                print("[ERROR] Could not save watch state for \(episode). \(error)")
                            }
                        }
                    }
            }
            .padding(.horizontal)
        }
    }
}

struct UpNextView_Previews: PreviewProvider {
    static let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    static var previews: some View {
        UpNextMainView(groupManager: GroupManager(config, 0))
    }
}
