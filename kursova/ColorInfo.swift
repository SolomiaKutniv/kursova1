//
//  ColorInfo.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 27.11.2025.
//

import Foundation

struct ColorInfo: Codable {
    let hex: Hex
    let rgb: RGB
    let name: Name
}

struct Hex: Codable {
    let value: String
}

struct RGB: Codable {
    let value: String
}

struct Name: Codable {
    let value: String
}


