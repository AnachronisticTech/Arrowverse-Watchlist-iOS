//
//  ShowFilterView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowFilterView<Content: View>: View {
    private var content: (Series) -> Content
    private var request: FetchRequest<Series>
    private var shows: FetchedResults<Series> {
        request.wrappedValue
    }

    init(
        group: SeriesCollection,
        @ViewBuilder _ content: @escaping (Series) -> Content
    ) {
        self.content = content
        request = FetchRequest<Series>(fetchRequest: DatabaseManager.getSeries(for: group))
    }

    var body: some View {
        List {
            Section(header: titleView("Choose shows to track")) {
                ForEach(shows) { show in
                    content(show)
                }
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder private func titleView(_ text: String) -> some View {
        HStack {
            Spacer()
            Text(text)
                .font(.title)
            Spacer()
        }
        .padding([.top])
    }
}

struct ShowFilterList_Previews: PreviewProvider {
    static var previews: some View {
        ShowFilterView(group: PersistenceController.group) { show in
            ShowView(show: show)
        }
    }
}
