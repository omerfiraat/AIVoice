//
//  VoiceResponse.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import Foundation

// Tek bir obje için model
struct Character: Codable {
    let imageUrl: String
    let category: String
    let order: Int
    let name: String
}

// JSON verisini tutan ana model
struct VoiceResponse: Codable {
    let objects: [Character]
}
