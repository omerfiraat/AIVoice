//
//  APIEndpoint.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case voiceAPI
    case generateAPI(request: GenerateRequest)

    private var baseURL: String {
        return "https://us-central1-ai-video-40ecf.cloudfunctions.net/"
    }

    var path: String {
        switch self {
        case .voiceAPI:
            return "\(baseURL)getVoice"
        case .generateAPI:
            return "\(baseURL)startMusicGenerate"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .voiceAPI:
            return .post
        case .generateAPI:
            return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .voiceAPI:
            return nil
        case .generateAPI(let request):
            return encodeRequestToDictionary(request)
        }
    }

    private func encodeRequestToDictionary<T: Encodable>(_ request: T) -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(request)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("Error encoding request: \(error)")
            return nil
        }
    }
}
