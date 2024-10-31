//
//  UIImage+Extensions.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from url: String) {
        guard let validURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        self.kf.setImage(with: validURL)
    }
    
    func loadImage(named imageName: String) {
        self.image = UIImage(named: imageName)
    }
}
