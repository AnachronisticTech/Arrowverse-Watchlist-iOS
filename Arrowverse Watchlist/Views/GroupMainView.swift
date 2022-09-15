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
    @Environment(\.managedObjectContext) private var viewContext

    @State private var isShowingError: TheMovieDBError?
    @State private var isShowingFilterSheet = false
    @State private var isShowingUpNextSheet = false
    @State private var isShowingReloadIndicator = false

    @StateObject var groupManager: GroupManager

    var body: some View {
        EpisodeListView(shows: Array(groupManager.trackedShows)) { episode in
            EpisodeView(episode: episode, show: groupManager.show(for: episode)!)
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
            ShowFilterView(groupManager: groupManager)
        }
        .sheet(isPresented: $isShowingUpNextSheet) {
            UpNextMainView(groupManager: groupManager)
        }
        .onChange(of: groupManager.isRequestInProgress) { value in
            isShowingReloadIndicator = value
        }
//        .onAppear {
//            groupManager.fetch(into: viewContext)
//        }
//        .pullToRefresh(isShowing: $isShowingReloadIndicator) {
//            groupManager.fetch(into: viewContext)
//        }
    }
}

struct GroupMainView_Previews: PreviewProvider {
    static let config: Config = try! JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Content", withExtension: "json")!))

    static var previews: some View {
        GroupMainView(groupManager: GroupManager(config, 0))
    }
}
