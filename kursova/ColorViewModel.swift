//
//  ColorViewModel.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 27.11.2025.
//
import SwiftUI
import Combine

class ColorViewModel: ObservableObject {
    
    @Published var colorInfo: ColorInfo? = nil
    @Published var isLoading: Bool = false
    @Published var favoritePalettes: [[String]] = []
    @Published var currentFavoritePalette: [String] = []
    
    init() {
        loadFavorites()
        generateRandomColor()
    }
    
    func loadFavorites() {
        if let data = UserDefaults.standard.array(forKey: "fav_palettes") as? [[String]] {
            favoritePalettes = data
        }
    }
    
    func generateRandomColor() {
        isLoading = true
        let randomHex = randomHexColor()
        let urlString = "https://www.thecolorapi.com/id?format=json&hex=\(randomHex)"
        fetchColor(from: urlString)
    }
    
    private func randomHexColor() -> String {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
    
    func fetchColor(from urlString: String) {
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }
            
            do {
                let decodedColor = try JSONDecoder().decode(ColorInfo.self, from: data)
                DispatchQueue.main.async {
                    self.colorInfo = decodedColor
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async { self.isLoading = false }
            }
        }.resume()
    }
    
    func addCurrentColorToFavorite() {
        guard let hex = colorInfo?.hex.value else { return }
        if !currentFavoritePalette.contains(hex) {
            currentFavoritePalette.append(hex)
        }
        
        if currentFavoritePalette.count == 5 {
            favoritePalettes.append(currentFavoritePalette)
            saveFavorites()
            currentFavoritePalette = []
        }
    }
    
    func isCurrentColorFavorite() -> Bool {
        guard let hex = colorInfo?.hex.value else { return false }
        return currentFavoritePalette.contains(hex)
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favoritePalettes, forKey: "fav_palettes")
    }
}







