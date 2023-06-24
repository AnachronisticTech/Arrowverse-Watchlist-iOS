//
//  ShowFilterView.swift
//  Arrowverse Watchlist
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowFilterView<Content: View>: View {
    @ObservedObject var group: SeriesCollection
    @ViewBuilder var content: (Series) -> Content

    var body: some View {
        List {
            Section(header: titleView("Choose shows to track")) {
                ForEach(group.shows) { show in
                    content(show)
                }
            }
        }
        .listStyle(.plain)
        .listRowInsets(.none)
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
