//
//  DropdownView.swift
//  AIVoice
//
//  Created by Mac on 5.11.2024.
//

import UIKit
import SnapKit

final class DropdownView: UIView {
    
    // MARK: - Properties
    private let stackView: UIStackView
    private let blurEffectView: UIVisualEffectView
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        stackView = UIStackView()
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        layer.cornerRadius = 8
        clipsToBounds = true
        isHidden = true
        
        blurEffectView.layer.cornerRadius = 8
        blurEffectView.clipsToBounds = true
        insertSubview(blurEffectView, at: 0)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Add Button
    func addButton(title: String, image: UIImage?, action: Selector, target: Any) {
        let containerView = UIView()
        
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(target, action: action, for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let image = image {
            imageView.image = image
        }

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }

        let horizontalStackView = UIStackView(arrangedSubviews: [titleLabel, imageView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.alignment = .center

        containerView.addSubview(horizontalStackView)
        containerView.addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        stackView.addArrangedSubview(containerView)
    }

    // MARK: - Show/Hide Dropdown
    func show(in view: UIView, at position: CGPoint) {
        self.center = position
        view.addSubview(self)
        isHidden = false
        
        // Constraints for positioning
        self.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(position.y)
            make.right.equalToSuperview().offset(-position.x)
            make.width.equalTo(200)
        }
    }
    
    func hide() {
        isHidden = true
        removeFromSuperview()
    }
}
