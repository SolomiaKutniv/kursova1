//
//  ContentView.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 20.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var currentColor: String = "#A35F79"
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                
                Text("Поточний колір: \(currentColor)")
                    .foregroundColor(.black)
                    .background(Color.white)
                    .padding()
                    .cornerRadius(5)
                    .padding(.top, 130)
                    .padding(.bottom, 25)
                Spacer()
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                            .padding(.leading, 20)
                    }

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "doc.on.clipboard.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing, 20)
                    }
                }

                Button(action: {
                    generateRandomColor()
                }) {
                    Text("Згенерувати")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }

                

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
            .background(Color(hex: currentColor))
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(
                leading: Button(action: {}) {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func generateRandomColor() {
        isLoading = true
        
        let colorURLs = [
            "https://www.thecolorapi.com/id?format=json&hex=A35F79",
            "https://www.thecolorapi.com/id?format=json&hex=5A70E2",
            "https://www.thecolorapi.com/id?format=json&hex=613E70",
            "https://www.thecolorapi.com/id?format=json&hex=8FBDDC",
            "https://www.thecolorapi.com/id?format=json&hex=A6445A"
        ]
        
        let randomColorURL = colorURLs.randomElement() ?? colorURLs[0]
        
        fetchColor(from: randomColorURL)
    }

    func fetchColor(from urlString: String) {
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                do {
                    let colorResponse = try JSONDecoder().decode(ColorResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.currentColor = colorResponse.hex.value
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ColorResponse: Codable {
    let hex: Hex
}

struct Hex: Codable {
    let value: String
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}








