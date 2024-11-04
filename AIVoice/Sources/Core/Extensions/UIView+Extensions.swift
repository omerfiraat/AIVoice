//
//  UIView+Extensions.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit
import SnapKit

extension UIView {
    
    func dynamicHeight(for baseHeight: CGFloat) -> CGFloat {
        let scaleFactor: CGFloat = baseHeight / 932
        return UIScreen.main.bounds.height * scaleFactor
    }
    
    func dynamicWidth(for baseWidth: CGFloat) -> CGFloat {
        let scaleFactor: CGFloat = baseWidth / 430
        return UIScreen.main.bounds.width * scaleFactor
    }
    
    func setDynamicHeight(for baseHeight: CGFloat) {
        self.snp.makeConstraints { make in
            make.height.equalTo(dynamicHeight(for: baseHeight))
        }
    }
    
    func setDynamicWidth(for baseWidth: CGFloat) {
        self.snp.makeConstraints { make in
            make.width.equalTo(dynamicWidth(for: baseWidth))
        }
    }
}
