//
//  EpisodeListView.swift
//  Arrowverse Watchlist 2
//
//  Created by Daniel Marriner on 20/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI
import TVDBKit

struct EpisodeListView: View {
    @State private var episodes = [(Episode, Show)]()
    @State private var isShowingError: TVDBError?
    @State private var isShowingFilterSheet = false

    @EnvironmentObject var showDataStore: ShowDataStore

    var body: some View {
        NavigationView {
            List {
                ForEach(episodes, id: \.0.id) { episode, show in
                    HStack {
                        HStack {
                            Image(uiImage: show.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 65, maxHeight: 65)
                        }
                        .frame(width: 65, height: 65, alignment: .center)
                        VStack(alignment: .leading) {
                            Text(episode.name)
                            Text("Airing (episode.airDate)")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color(show.color.cgColor))
                }
            }
            .id(UUID())
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: showDataStore.episodeLibrary) { _ in
                episodes = showDataStore.projectedEpisodes
            }
            .onChange(of: showDataStore.trackedShows) { _ in
                episodes = showDataStore.projectedEpisodes
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: showDataStore.fetch) {
                        if showDataStore.requestsInProgress == 0 {
                            Image(systemName: "arrow.clockwise")
                        } else {
                            ProgressView()
                        }
                    }
                    .disabled(showDataStore.requestsInProgress > 0)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingFilterSheet = true }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {  }) {
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
            Text("Choose your Arrowverse shows to track")
                .font(.title)
                .padding([.top])
            ScrollView {
                LazyVStack {
                    ForEach(Show.allCases, id: \.self) { show in
                        HStack {
                            HStack {
                                Image(uiImage: show.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 65, maxHeight: 65)
                            }
                            .frame(width: 65, height: 65, alignment: .center)
                            .padding(10)
                            Text(show.name)
                                .font(.title)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .background(showDataStore.trackedShows.contains(show) ? Color(show.color.cgColor) : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding([.leading, .bottom, .trailing], 5)
                        .onTapGesture {
                            if showDataStore.trackedShows.contains(show) {
                                showDataStore.trackedShows.remove(show)
                            } else {
                                showDataStore.trackedShows.insert(show)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

extension Episode: Hashable {
    public static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Episode: Identifiable {}

extension TVDBError: Identifiable {
    public var id: Int {
        switch self {
            case .bearerTokenNotSetError: return 0
            case .transporError(_): return 1
            case .serverError(_): return 2
            case .emptyData: return 3
            case .decodingError(_): return 4
        }
    }
}

class ShowDataStore: ObservableObject {
    static var shared = ShowDataStore()

    private init() {}

    @Published var requestsInProgress = 0
    @Published var episodeLibrary = [Show: [Episode]]()

    var projectedEpisodes: [(Episode, Show)] {
        episodeLibrary
            .reduce([]) { arr, dict in
                if trackedShows.contains(dict.key) {
                    var arr = arr
                    arr.append(contentsOf: dict.value.map { ($0, dict.key) })
                    return arr
                }
                return arr
            }
            .sorted(by: { $0.0.airDate < $1.0.airDate })
    }

    @Published var trackedShows = Set<Show>([
        .Arrow, .Constantine, .Flash,
//        .Legends,
        .Supergirl, .Vixen, .BlackLightning, .Batwoman,
        .Titans, .DoomPatrol, .Stargirl, .Superman
    ])

    func fetch() {
        for show in trackedShows {
            requestsInProgress += 1
            TVDB.Convenience.getEpisodes(ofShowWithId: show.tvdbId) { [self] result in
                switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let episodes):
                        DispatchQueue.main.async {
                            episodeLibrary[show] = episodes
                        }
                }
                DispatchQueue.main.async {
                    requestsInProgress -= 1
                }
            }
        }
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView()
            .environmentObject(ShowDataStore.shared)
    }
}
