//
//  InspirationButtonView.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit
import SnapKit

final class InspirationButtonView: UIView {
    
    //MARK: - Action Button
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.primaryColor1, for: .normal)
        button.titleLabel?.font = UIFont.boldFont(ofSize: 15)
        return button
    }()
    
    //MARK: - Image View
    private let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.loadImage(named: "inspirationImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(actionButton)
        addSubview(actionImageView)
        
        actionButton.setUnderlinedText("Get inspiration")
        
        actionButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        actionImageView.snp.makeConstraints { make in
            make.leading.equalTo(actionButton.snp.trailing).offset(3)
            make.centerY.equalTo(actionButton)
            make.trailing.equalToSuperview()
            make.width.equalTo(13.75)
            make.height.equalTo(17.5)
        }
    }
    
    func setButtonAction(target: Any, action: Selector) {
        actionButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
