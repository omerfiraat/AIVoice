//
//  GradientButton.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import UIKit

class GradientButton: UIButton {
    
    // MARK: - Properties
    
    private var gradientLayer: CAGradientLayer?
    
    var gradientColors: [UIColor]? {
        didSet {
            applyGradient()
        }
    }
    
    var cornerRadius: CGFloat = 12 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var titleColor: UIColor = .white {
        didSet {
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    
    private func setupButton() {
        backgroundColor = .clear
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        layer.masksToBounds = true
        applyGradient()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient()
    }
    
    // MARK: - Gradient
    
    private func applyGradient() {
        if let colors = gradientColors, !colors.isEmpty {
            if gradientLayer == nil {
                gradientLayer = CAGradientLayer()
                layer.insertSublayer(gradientLayer!, at: 0)
            }
            
            gradientLayer?.colors = colors.map { $0.cgColor }
            gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer?.frame = bounds
            gradientLayer?.isHidden = false
        } else {
            gradientLayer?.isHidden = true
        }
    }
}
