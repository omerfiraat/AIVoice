//
//  ViewController.swift
//  AIVoice
//
//  Created by Mac on 30.10.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Properties
    private let promptTextView = PromptTextView()
    private let inspirationButtonView = InspirationButtonView()
    
    private var lastInspiration: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBarTitle()
        setupConstraints()
        setupButtonAction()
    }

    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(promptTextView)
        view.addSubview(inspirationButtonView)
    }
    
    private func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "AI Voice"
        titleLabel.font = UIFont.boldFont(ofSize: 17)
        titleLabel.textColor = .systemWhite
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }

    private func setupConstraints() {
        promptTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(122)
            make.left.right.equalToSuperview().inset(16)
        }
        
        inspirationButtonView.snp.makeConstraints { make in
            make.left.equalTo(promptTextView.snp.left).offset(22)
            make.bottom.equalTo(promptTextView.snp.bottom).offset(-7)
        }
    }
    
    private func setupButtonAction() {
        inspirationButtonView.setButtonAction(target: self, action: #selector(actionButtonTapped))
    }

    // MARK: - Actions
    @objc private func actionButtonTapped() {
        promptTextView.resignFirstResponder()
        let randomInspiration = getRandomInspiration()
        promptTextView.setTextContent(randomInspiration)
        print("Selected inspiration: \(randomInspiration)")
    }

    // MARK: - Helper Methods
    private func getRandomInspiration() -> String {
        var randomInspiration: String
        
        repeat {
            randomInspiration = Inspirations.quotes.randomElement() ?? "No inspiration available"
        } while randomInspiration == lastInspiration
        
        lastInspiration = randomInspiration
        
        return randomInspiration
    }
}
