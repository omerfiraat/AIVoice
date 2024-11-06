//
//  LandingVM.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

final class LandingVM {
    
    var characters: VoiceResponse?
    var filteredCharacters: [Character] = []
    var categories: [String] = []
    var selectedCharacter: Character?


    func fetchVoiceAPI(_ completion: @escaping () -> Void) {
        NetworkManager.shared.request(endpoint: .voiceAPI, type: VoiceResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.characters = response
                self?.filteredCharacters = response.objects // Initially set to all voices
                self?.extractUniqueCategories(from: response)
                completion()
            case .failure(let error):
                print("Error fetching voice API: \(error)")
            }
        }
    }
    
    private func extractUniqueCategories(from response: VoiceResponse) {
        var uniqueCategoriesSet = Set<String>()
        for character in response.objects {
            uniqueCategoriesSet.insert(character.category)
        }
        
        categories = Array(uniqueCategoriesSet)
        categories.insert("All", at: 0) // Insert "All" as the first element
    }
    
    func filterCharacters(by category: String) {
        guard let characters = characters?.objects else { return }
        if category == "All" {
            filteredCharacters = characters // Show all voices when "All" is selected
        } else {
            filteredCharacters = characters.filter { $0.category == category } // Filter by selected category
        }
    }
}
