//
//  FavoritesView.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 27.11.2025.
//

import SwiftUI

struct PaletteView: View {
    let colors: [String]

    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { hex in
                Color(hex: hex)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
        }
    }
}

struct FavoritesView: View {
    @ObservedObject var vm: ColorViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.favoritePalettes, id: \.self) { palette in
                    PaletteView(colors: palette)
                        .padding(.vertical, 5)
                }
            }
            .navigationTitle("Улюблені палітри")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}





