//
//  FontExtensions.swift
//  AIVoice
//
//  Created by Mac on 30.10.2024.
//

import UIKit

extension UIFont {
    static func regularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func boldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
