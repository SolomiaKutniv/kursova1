//
//  ColorInfo.swift
//  kursova
//
//  Created by ІПЗ-31/2 on 27.11.2025.
//

import Foundation

struct ColorInfo: Codable {
    let name: Name
    let hex: Hex
    let rgb: RGB
}

struct Name: Codable {
    let value: String
}

struct Hex: Codable {
    let value: String
}

struct RGB: Codable {
    let value: String
}

struct ColorPair: Codable, Hashable {
    let userHex: String
    let randomHex: String
}








