//
//  AnimationVM.swift
//  AIVoice
//
//  Created by Mac on 2.11.2024.
//

final class AnimationVM {
    
    var selectedCharacter: Character?

    func generateApi(_ request: GenerateRequest, completion: @escaping (Result<GenerateResponse, Error>) -> Void) {
        NetworkManager.shared.request(endpoint: .generateAPI(request: request), type: GenerateResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
