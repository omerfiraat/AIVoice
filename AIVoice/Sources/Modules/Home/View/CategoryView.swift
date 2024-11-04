//
//  CategoryView.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import UIKit
import SnapKit

protocol CategoryViewDelegate: AnyObject {
    func didTapCategory(_ category: String)
}

final class CategoryView: UIView {
    
    // MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    weak var delegate: CategoryViewDelegate?
    private lazy var categories: [String] = []
    private var selectedButton: UIButton?

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setCategories(_ categories: [String]) {
        self.categories = categories
        setupCategories()
    }
    
    private func setupCategories() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.setTitleColor(.systemWhite, for: .normal)
            button.titleLabel?.font = .regularFont(ofSize: 15)
            button.layer.cornerRadius = 8
            button.backgroundColor = .systemDark
            button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.clear.cgColor
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
            button.snp.makeConstraints { make in
                make.height.equalTo(44)
                make.width.greaterThanOrEqualTo(80)
            }
            
            stackView.addArrangedSubview(button)
            
            if categories.first == category {
                selectedButton = button
                button.layer.borderColor = UIColor.primaryColor1.cgColor
                delegate?.didTapCategory(category)
            }
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        if sender == selectedButton {
            return
        }
        
        guard let title = sender.title(for: .normal) else { return }
        delegate?.didTapCategory(title)
        
        if let previousSelectedButton = selectedButton {
            UIView.animate(withDuration: 0.3) {
                previousSelectedButton.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        selectedButton = sender
        
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.primaryColor1.cgColor
        }
    }
}
