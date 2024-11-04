//
//  AnimationView.swift
//  AIVoice
//
//  Created by Mac on 2.11.2024.
//

import UIKit
import SnapKit

final class AnimationView: UIView {
    
    // MARK: - UI Components
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.loadImage(named: "backBlur")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let rotatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.loadImage(named: "generateImage")
        return imageView
    }()
    
    // MARK: - Properties
    
    private var rotationAnimation: CABasicAnimation?

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Methods

    private func setupViews() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(rotatingImageView)
        rotatingImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            rotatingImageView.setDynamicWidth(for: 240)
            rotatingImageView.setDynamicHeight(for: 240)
        }
    }
    
    // MARK: - Animation Methods

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = CGFloat(Double.pi * 2)
        animation.duration = 2
        animation.isCumulative = true
        animation.repeatCount = .infinity
        rotationAnimation = animation
        
        rotatingImageView.layer.add(animation, forKey: "rotationAnimation")
    }
    
    func stopAnimating() {
        rotatingImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    // MARK: - Helper Methods

    func setBackgroundImage(_ image: UIImage?) {
        backgroundImageView.image = image
    }
    
    func setRotatingImage(_ image: UIImage?) {
        rotatingImageView.image = image
    }
}
