//
//  FavoritesView.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 27.11.2025.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var pairs: [ColorPair]

    var body: some View {
        NavigationStack {
            List {
                ForEach(pairs, id: \.self) { pair in
                    HStack {
                        Color(hex: pair.userHex)
                        Color(hex: pair.randomHex)
                    }
                    .frame(height: 60)
                    .cornerRadius(8)
                }
                .onDelete { indexSet in
                    pairs.remove(atOffsets: indexSet)
                    if let data = try? JSONEncoder().encode(pairs) {
                        UserDefaults.standard.set(data, forKey: "fav_pairs")
                    }
                }
            }
            .navigationTitle("Улюблені поєднання")
            .toolbar {
                EditButton()
            }
        }
    }
}











