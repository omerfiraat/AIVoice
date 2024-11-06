//
//  ResultVM.swift
//  AIVoice
//
//  Created by Mac on 5.11.2024.
//

import UIKit

final class ResultVM {
    
    // MARK: - Properties
    var audioURL: URL?
    var onCopyTextSuccess: (() -> Void)?
    var onDownloadSuccess: ((URL) -> Void)? // Closure to handle successful download

    // MARK: - Methods

    /// Copies the given text to the clipboard and notifies the view controller about the success.
    /// - Parameter text: The text to copy.
    func copyText(from text: String) {
        UIPasteboard.general.string = text
        // Notify the view controller about the success
        onCopyTextSuccess?()
    }
    
    /// Returns the audio URL if available for sharing.
    /// - Returns: The audio URL or nil if not set.
    func share() -> URL? {
        return audioURL
    }
    
    /// Downloads the MP3 file from the audio URL.
    func downloadMP3() {
        guard let mp3Url = audioURL else { return }
        downloadFile(from: mp3Url)
    }

    private func downloadFile(from url: URL) {
        let task = URLSession.shared.downloadTask(with: url) { [weak self] location, response, error in
            guard let self = self, let location = location, error == nil else {
                print("İndirme hatası: \(error?.localizedDescription ?? "Bilinmiyor")")
                return
            }

            // Geçici dosya yolu ve benzersiz dosya adı oluştur
            let uniqueFileName = self.generateUniqueFileName()
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(uniqueFileName)

            do {
                // Dosyayı hedef konuma taşı
                try FileManager.default.moveItem(at: location, to: destinationURL)
                // Notify success with the destination URL
                self.onDownloadSuccess?(destinationURL)
            } catch {
                print("Dosya taşınamadı: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    private func generateUniqueFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = formatter.string(from: Date())
        return "downloadedFile_\(dateString).mp3"
    }
}
