//
//  UIButton+Extensions.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit

extension UIButton {
    func setUnderlinedText(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
