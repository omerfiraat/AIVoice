//
//  UIImage+Extensions.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit
import Kingfisher
import Alamofire

extension UIImageView {
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    func setImage(from url: String, completion: @escaping (Bool) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(false)
            return
        }
        
        AF.request(imageUrl).responseData { response in
            switch response.result {
            case .success(let data):
                self.image = UIImage(data: data)
                completion(true) // Image loaded successfully
            case .failure:
                completion(false) // Loading failed
            }
        }
    }
    
    private func downloadImage(from url: String) {
        guard let validURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }

        AF.request(validURL).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.image = image
                    
                    // Cache the image
                    UIImageView.imageCache.setObject(image, forKey: url as NSString)
                }
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
    func loadImage(from url: String) {
        guard let validURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            return
        }
        
        self.kf.setImage(with: validURL) { [weak self] result in
            switch result {
            case .success(let value):
                UIImageView.imageCache.setObject(value.image, forKey: url as NSString) // Cache the loaded image
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
                self?.image = nil // Optionally set a placeholder image here
            }
        }
    }
    
    func loadImage(named imageName: String) {
        self.image = UIImage(named: imageName)
    }
}
