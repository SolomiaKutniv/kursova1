//
//  ColorViewModel.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 27.11.2025.
//
import SwiftUI
import Combine

class ColorViewModel: ObservableObject {
    @Published var randomColorInfo: ColorInfo?
    @Published var isLoading: Bool = false
    @Published var userColor: Color = .red
    @Published var userHex: String = "#FF0000"
    @Published var favoritePairs: [ColorPair] = []

    init() {
        loadFavorites()
        generateRandomColor()
    }

    func generateRandomColor() {
        isLoading = true
        let hex = randomHexColor()
        let url = "https://www.thecolorapi.com/id?format=json&hex=\(hex)"
        fetchColor(from: url)
    }

    private func randomHexColor() -> String {
        String(
            format: "%02X%02X%02X",
            Int.random(in: 0...255),
            Int.random(in: 0...255),
            Int.random(in: 0...255)
        )
    }

    private func fetchColor(from urlString: String) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }

            if let decoded = try? JSONDecoder().decode(ColorInfo.self, from: data) {
                DispatchQueue.main.async {
                    self.randomColorInfo = decoded
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }

    func saveCurrentPair() {
        guard let randomHex = randomColorInfo?.hex.value else { return }
        let pair = ColorPair(userHex: userHex, randomHex: randomHex)

        if !favoritePairs.contains(pair) {
            favoritePairs.append(pair)
            saveFavorites()
        }
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoritePairs) {
            UserDefaults.standard.set(data, forKey: "fav_pairs")
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "fav_pairs"),
           let decoded = try? JSONDecoder().decode([ColorPair].self, from: data) {
            favoritePairs = decoded
        }
    }
}












