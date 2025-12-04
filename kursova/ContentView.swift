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
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let color = vm.colorInfo {
                    Text("HEX: \(color.hex.value), Колір: \(color.name.value)")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .padding(.top, 130)
                        .padding(.bottom, 5)

                    Text("\(color.rgb.value)")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .padding(.bottom, 5)

                    Color(hex: color.hex.value)
                        .frame(width: 200, height: 200)
                        .cornerRadius(8)
                        .padding()
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        vm.addCurrentPalette()
                    }) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                            .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = vm.colorInfo?.hex.value ?? ""
                    }) {
                        Image(systemName: "doc.on.clipboard.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing, 20)
                    }
                }
                
                Button(action: {
                    vm.generateRandomColor()
                }) {
                    Text("Згенерувати")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
                
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
            .background(Color(hex: vm.colorInfo?.hex.value ?? "#FFFFFF"))
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(
                leading: Button(action: {
                    showFavorites = true
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
            )
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showFavorites) {
                FavoritesView(vm: vm)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}









