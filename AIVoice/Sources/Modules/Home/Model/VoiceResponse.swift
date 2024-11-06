//
//  VoiceResponse.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import Foundation

struct Character: Codable {
    let imageUrl: String
    let category: String
    let order: Int
    var name: String
}

struct VoiceResponse: Codable {
    let objects: [Character]
}
