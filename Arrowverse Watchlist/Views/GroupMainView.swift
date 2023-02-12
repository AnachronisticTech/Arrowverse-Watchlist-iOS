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

    @ObservedObject var group: ShowGroupDB

    var body: some View {
        EpisodeListView(shows: group.trackedShows) { episode in
            EpisodeView(episode: episode)
                .onTapGesture {
                    DatabaseManager.toggleWatchedStatus(for: episode)
                }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    isShowingFilterSheet = true
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
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
            ShowFilterView(group: group)
        }
        .sheet(isPresented: $isShowingUpNextSheet) {
            UpNextMainView(group: group)
        }
        .onChange(of: isRequestInProgress) { value in
            isShowingReloadIndicator = value
        }
        .onAppear {
//            print(group.shows.flatMap({ $0.episodes }).map({ $0.name }))
            for show in group.shows where !show.hasPerformedFirstFetch {
                print(show.name)
                fetch(show)
            }
        }
        .pullToRefresh(isShowing: $isShowingReloadIndicator) {
            guard requestsInProgress == 0 else { return }
            for show in group.shows {
                fetch(show)
            }
        }
    }

    func fetch(_ show: ShowDB) {
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

//struct GroupMainView_Previews: PreviewProvider {
//    static let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))
//
//    static var previews: some View {
//        GroupMainView(groupManager: GroupManager(config, 0))
//    }
//}
