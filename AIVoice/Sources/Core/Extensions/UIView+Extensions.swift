//
//  UIView+Extensions.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit

extension UIView {
    static func dynamicHeight(for baseHeight: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let scaleFactor: CGFloat = baseHeight / 932
        return screenHeight * scaleFactor
    }
    
    static func dynamicWidth(for baseWidth: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor: CGFloat = baseWidth / 430
        return screenWidth * scaleFactor
    }
}
