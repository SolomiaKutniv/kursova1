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
        NavigationView {
            List {
                ForEach(vm.favoritePalettes.indices, id: \.self) { index in
                    PaletteView(colors: vm.favoritePalettes[index])  // Використовуємо PaletteView тут
                }
            }
            .navigationTitle("Улюблені палітри")
        }
    }
}




