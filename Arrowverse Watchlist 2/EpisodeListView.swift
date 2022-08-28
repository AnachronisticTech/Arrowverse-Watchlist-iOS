//
//  EpisodeListView.swift
//  Arrowverse Watchlist 2
//
//  Created by Daniel Marriner on 20/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import CoreData
import TVDBKit
import SwiftUIRefresh

struct EpisodeListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var isShowingError: TVDBError?
    @State private var isShowingFilterSheet = false
    @State private var isShowingUpNextSheet = false
    @State private var isShowingReloadIndicator = false

    @EnvironmentObject var showDataStore: ShowDataStore

    var body: some View {
        NavigationView {
            List {
                ForEach(showDataStore.episodes) { episode in
                    EpisodeView(episode: episode)
                        .onTapGesture {
                            if episode.airDate < Date(timeIntervalSinceNow: 0) {
                                showDataStore.toggleWatchedStatus(for: episode)
                            }
                        }
                }
            }
            .id(UUID())
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: showDataStore.trackedShows) { _ in
                showDataStore.loadEpisodes()
            }
            .onChange(of: showDataStore.requestsInProgress) { value in
                isShowingReloadIndicator = value != 0
            }
            .pullToRefresh(isShowing: $isShowingReloadIndicator, onRefresh: showDataStore.fetch)
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
        }
        .onAppear(perform: showDataStore.fetch)
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

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView()
            .environmentObject(ShowDataStore.shared)
    }
}
