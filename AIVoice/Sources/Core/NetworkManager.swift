//
//  NetworkManager.swift
//  AIVoice
//
//  Created by Mac on 30.10.2024.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case rateLimitExceeded(resetTime: TimeInterval)
    case invalidData
    case unauthorized
    case forbidden
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(endpoint: APIEndpoint, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let url = endpoint.path
        
        print("Requesting URL: \(url) with method: \(endpoint.method.rawValue)")
        
        AF.request(url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                
                // Response Status Code'u logla
                print("Response Status Code: \(response.response?.statusCode ?? 0)")
                
                switch response.result {
                case .success(let data):
                    // JSON verilerini logla
                    print("Response Data: \(data)")
                    completion(.success(data))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            completion(.failure(.unauthorized))
                        case 403:
                            completion(.failure(.forbidden))
                        default:
                            print("Error fetching data: \(error)")
                            completion(.failure(.failedRequest))
                        }
                    } else {
                        completion(.failure(.failedRequest))
                    }
                }
            }
    }
}
