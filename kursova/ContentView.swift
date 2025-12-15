//
//  ContentView.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 20.11.2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ColorViewModel()
    @State private var showFavorites = false
    @State private var isFavorite = false
    @State private var copiedUser = false
    @State private var copiedRandom = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                Color(vm.userColor)
                    .frame(width: 250, height: 290)
                    .cornerRadius(14)
                    .position(x: 140, y: 190)

                if let color = vm.randomColorInfo {
                    Color(hex: color.hex.value)
                        .frame(width: 250, height: 290)
                        .cornerRadius(14)
                        .position(x: 260, y: 370)
                }

                VStack {
                    HStack {
                        Button {
                            showFavorites = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "line.horizontal.3")
                                    .resizable()
                                    .frame(width: 26, height: 20)
                                    .foregroundColor(.black)
                            }
                        }

                        Spacer()
                    }
                    .padding()

                    Spacer()
                }

                VStack(spacing: 4) {
                    ColorPicker("", selection: $vm.userColor, supportsOpacity: false)
                        .labelsHidden()
                        .frame(width: 26, height: 26)
                        .clipped()
                        .onChange(of: vm.userColor) { newColor in
                            vm.userHex = newColor.toHex()
                            isFavorite = false
                        }
                }
                .position(x: 30, y: 360)

                VStack(spacing: 8) {
                    if let color = vm.randomColorInfo {
                        VStack(spacing: 4) {
                            Text(color.name.value)
                                .font(.body)
                                .foregroundColor(.black)
                            Text(color.rgb.value)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            HStack {
                                Text(color.hex.value)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Button {
                                    UIPasteboard.general.string = color.hex.value
                                    copiedRandom = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        copiedRandom = false
                                    }
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(.blue)
                                }
                            }
                            if copiedRandom {
                                Text("Скопійовано!")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .position(x: 260, y: 470)
                    }

                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Text(vm.userColor.toHex())
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Button {
                                UIPasteboard.general.string = vm.userColor.toHex()
                                copiedUser = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    copiedUser = false
                                }
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blue)
                            }
                        }
                        if copiedUser {
                            Text("Скопійовано!")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    .position(x: 60, y: -90)
                }

                VStack(spacing: 4) {
                    Button {
                        vm.generateRandomColor()
                        isFavorite = false
                    } label: {
                        Text("Згенерувати")
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(width: 250)
                            .background(Color(red: 0.7, green: 0.5, blue: 0.95))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
                .position(x: 260, y: 550)

                VStack {
                    Spacer()
                    HStack {
                        Button {
                            vm.saveCurrentPair()
                            isFavorite.toggle()
                        } label: {
                            VStack {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .resizable()
                                    .frame(width: 38, height: 34)
                                    .foregroundColor(isFavorite ? .red : .white)
                                    .overlay(
                                        Image(systemName: "heart")
                                            .resizable()
                                            .frame(width: 38, height: 34)
                                            .foregroundColor(.black)
                                    )
                            }
                        }

                        Spacer()
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 10)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showFavorites) {
                FavoritesView(pairs: $vm.favoritePairs)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





















