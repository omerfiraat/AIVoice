//
//  GenerateRequest.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import Foundation

struct GenerateRequest: Encodable {
    let prompt: String
    let cover: String
}
