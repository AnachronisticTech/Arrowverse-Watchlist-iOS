//
//  EpisodeListView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 20/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import CoreData
import TVDBKit
import SwiftUIRefresh

struct EpisodeListView_New: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var isShowingError: TVDBError?
    @State private var isShowingFilterSheet = false
    @State private var isShowingUpNextSheet = false
    @State private var isShowingReloadIndicator = false

    @StateObject var groupManager: GroupManager

    var body: some View {
        List {
            ForEach(groupManager.episodes) { episode in
                EpisodeView(episode: episode, show: groupManager.show(for: episode))
                    .onTapGesture {
                        if episode.airDate < Date(timeIntervalSinceNow: 0) {
                            groupManager.toggleWatchedStatus(for: episode)
                        }
                    }
            }
        }
        .id(UUID())
        .navigationTitle(groupManager.groupData.name)
        .onChange(of: groupManager.trackedShows) { _ in
            groupManager.loadEpisodes()
        }
        .onChange(of: groupManager.isRequestInProgress) { value in
            isShowingReloadIndicator = value
        }
        .pullToRefresh(isShowing: $isShowingReloadIndicator, onRefresh: groupManager.fetch)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { isShowingFilterSheet = true }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isShowingUpNextSheet = true }) {
                    Image(systemName: "calendar")
                }
            }
        }
        .onAppear(perform: groupManager.fetch)
        .alert(item: $isShowingError) { error in
            Alert(
                title: Text("Error"),
                message: Text(String(describing: error)),
                dismissButton: .default(Text("Ok"))
            )
        }
        .sheet(isPresented: $isShowingFilterSheet) {
            ShowFilterList()
        }
        .sheet(isPresented: $isShowingUpNextSheet) {
            UpNextView()
        }
    }
}

struct EpisodeListView_New_Previews: PreviewProvider {
    static let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    static var previews: some View {
        EpisodeListView_New(groupManager: GroupManager(config, 0))
    }
}
