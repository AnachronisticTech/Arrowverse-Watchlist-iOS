//
//  ShowSearchView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 15/09/2022.
//  Copyright © 2022 Daniel Marriner. All rights reserved.
//

import SwiftUI
import TheMovieDBKit

struct ShowSearchView: View {
    @Environment(\.managedObjectContext) var viewContext

    private var group: SeriesCollection
    private var request: FetchRequest<Series>
    private var shows: FetchedResults<Series> {
        request.wrappedValue
    }

    @State private var searchTerm = ""
    @State private var searchResults: SeriesSearchResult?
    @State private var isShowingError: TheMovieDBError?

    init(group: SeriesCollection) {
        self.group = group
        request = FetchRequest<Series>(fetchRequest: DatabaseManager.getSeries(for: group))
    }

    var body: some View {
        VStack {
            searchBarView()
                .padding()

            List {
                ForEach(searchResults?.results ?? [], id: \.id) { result in
                    HStack {
                        if let imagePath = result.posterPath {
                            AsyncImageView(path: imagePath, imageFunc: Utils.imageData)
                                .frame(height: 100)
                        }
                        Text(result.name)
                        Spacer()
                        Button {
                            if let show = shows.first(where: { $0.id == result.id }) {
                                DatabaseManager.delete(show)
                            } else {
                                DatabaseManager.save(result, into: group)
                            }
                        } label: {
                            if shows.contains(where: { $0.id == result.id }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .listRowInsets(.init())
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Search for a show")
        .alert(item: $isShowingError) { error in
            Alert(
                title: Text("Error"),
                message: Text(String(describing: error)),
                dismissButton: .default(Text("Ok"))
            )
        }
    }

    @ViewBuilder private func searchBarView() -> some View {
        HStack {
            TextField("Name", text: $searchTerm)
                .textFieldStyle(.roundedBorder)

            if !searchTerm.isEmpty {
                Button {
                    searchTerm = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }

            Button("Search") {
                guard !searchTerm.isEmpty else { return }
                TheMovieDB.Search.shows(searchTerm) { result in
                    switch result {
                        case .success(let searchResults):
                            self.searchResults = searchResults
                        case .failure(let error):
                            isShowingError = error
                    }
                }
            }
        }
    }
}

struct ShowSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShowSearchView(group: PersistenceController.group)
        }
    }
}
