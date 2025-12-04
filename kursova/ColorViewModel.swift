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
    @Published var lastColors: [String] = []
    @Published var favoritePalettes: [[String]] = []
    
    let colorURLs: [String] = [
        "https://www.thecolorapi.com/id?format=json&hex=A35F79",
        "https://www.thecolorapi.com/id?format=json&hex=5A70E2",
        "https://www.thecolorapi.com/id?format=json&hex=613E70",
        "https://www.thecolorapi.com/id?format=json&hex=8FBDDC",
        "https://www.thecolorapi.com/id?format=json&hex=A6445A",
        "https://www.thecolorapi.com/id?format=json&hex=35B265",
        "https://www.thecolorapi.com/id?format=json&hex=930705",
        "https://www.thecolorapi.com/id?format=json&hex=3B6379",
        "https://www.thecolorapi.com/id?format=json&hex=D0DC8A",
        "https://www.thecolorapi.com/id?format=json&hex=D19E66",
        "https://www.thecolorapi.com/id?format=json&hex=7AA5A0",
        "https://www.thecolorapi.com/id?format=json&hex=3C0D32"
    ]
    
    init() {
        self.loadFavorites()
    }
    
    func loadFavorites() {
        if let data = UserDefaults.standard.array(forKey: "fav_palettes") as? [[String]] {
            favoritePalettes = data
        }
    }
    
    func generateRandomColor() {
        isLoading = true
        let url = colorURLs.randomElement() ?? colorURLs[0]
        fetchColor(from: url)
    }
    
    func fetchColor(from urlString: String) {
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            do {
                let decodedColor = try JSONDecoder().decode(ColorInfo.self, from: data)
                
                DispatchQueue.main.async {
                    self.colorInfo = decodedColor
                    self.isLoading = false
                    self.addToRecent(decodedColor.hex.value)
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func addToRecent(_ hex: String) {
        lastColors.append(hex)
        if lastColors.count > 5 {
            lastColors.removeFirst()
        }
    }
    
    func addCurrentPalette() {
        if lastColors.count == 5 {
            favoritePalettes.append(lastColors)
            saveFavorites()
        }
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favoritePalettes, forKey: "fav_palettes")
    }
}





