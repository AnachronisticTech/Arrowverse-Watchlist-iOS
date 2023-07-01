//
//  GroupMainView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 04/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh
import TheMovieDBKit

struct GroupMainView: View {
    @State private var isShowingError: TheMovieDBError?
    @State private var isShowingFilterSheet = false
    @State private var isShowingUpNextSheet = false

    @State private var requestsInProgress = 0
    private var isRequestInProgress: Bool { requestsInProgress > 0 }
    @State private var isShowingReloadIndicator = false

    private var group: SeriesCollection
    private var request: FetchRequest<Series>
    private var shows: [Series] {
        request.wrappedValue.map({ $0 })
    }

    init(group: SeriesCollection) {
        self.group = group
        request = FetchRequest<Series>(fetchRequest: DatabaseManager.getSeries(for: group))
    }

    var body: some View {
        EpisodeListView(shows: shows.filter({ $0.isTracking })) { episode in
            EpisodeView(episode: episode)
                .onTapGesture {
                    DatabaseManager.toggleWatchedStatus(for: episode)
                }
        }
        .navigationTitle(group.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingFilterSheet = true
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isShowingUpNextSheet = true
                } label: {
                    Image(systemName: "calendar")
                }
            }
        }
        .alert(item: $isShowingError) { error in
            Alert(
                title: Text("Error"),
                message: Text(String(describing: error)),
                dismissButton: .default(Text("Ok"))
            )
        }
        .sheet(isPresented: $isShowingFilterSheet) {
            ShowFilterView(group: group) { show in
                ShowView(show: show)
                    .onTapGesture {
                        DatabaseManager.toggleTrackingStatus(for: show)
                    }
            }
        }
        .sheet(isPresented: $isShowingUpNextSheet) {
            UpNextListView(shows: shows) { episode in
                EpisodeView(episode: episode)
                    .onTapGesture {
                        DatabaseManager.toggleWatchedStatus(for: episode)
                    }
            }
        }
        .onChange(of: isRequestInProgress) { value in
            isShowingReloadIndicator = value
        }
        .onAppear {
//            print(group.shows.flatMap({ $0.episodes }).map({ $0.name }))
            for show in shows where !show.hasPerformedFirstFetch {
                print(show.name)
                fetch(show)
            }
        }
        .pullToRefresh(isShowing: $isShowingReloadIndicator) {
            guard requestsInProgress == 0 else { return }
            for show in shows {
                fetch(show)
            }
        }
    }

    func fetch(_ show: Series) {
        requestsInProgress += 1
        TheMovieDB.Convenience.getEpisodes(ofShow: Int(show.id)) { result in
            switch result {
                case .failure(let error):
                    print(error)
                    if case .seasonDecodingError(_, let episodes) = error {
                        DatabaseManager.save(episodes, into: show)
                    }
                case .success(let episodes):
                    DatabaseManager.save(episodes, into: show)
            }
            DispatchQueue.main.async {
                self.requestsInProgress -= 1
            }
        }
    }
}

struct GroupMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GroupMainView(group: PersistenceController.group)
        }
    }
}
