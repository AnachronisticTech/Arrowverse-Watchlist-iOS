//
//  ShowFilterList.swift
//  Arrowverse Watchlist 2
//
//  Created by Daniel Marriner on 21/08/2021.
//  Copyright © 2021 Daniel Marriner. All rights reserved.
//

import SwiftUI

struct ShowFilterList: View {
    @EnvironmentObject var showDataStore: ShowDataStore

    var body: some View {
        Text("Choose your Arrowverse shows to track")
            .font(.title)
            .padding([.top, .horizontal])
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
                    .onChange(of: showDataStore.trackedShows) { value in
                        UserDefaults.standard
                            .set(try? JSONEncoder().encode(value), forKey: "tracked_shows")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ShowFilterList_Previews: PreviewProvider {
    static var previews: some View {
        ShowFilterList()
            .environmentObject(ShowDataStore.shared)
    }
}
