//
//  PromptTextView.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit
import SnapKit

final class PromptTextView: UITextView, UITextViewDelegate {
    
    private let placeholderText = "Write a text and let AI turn it into a speech with the voice of your favorite character"
    
    // MARK: - Initializers
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextView()
    }
    
    // MARK: - Setup Methods
    
    private func configureTextView() {
        setupAppearance()
        setupPlaceholder()
        setupConstraints()
        
        delegate = self
    }
    
    private func setupAppearance() {
        font = UIFont.regularFont(ofSize: 17)
        textColor = .systemGray2
        backgroundColor = .systemDark
        layer.cornerRadius = 8
        clipsToBounds = true
        textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private func setupPlaceholder() {
        text = placeholderText
        isEditable = true
    }
    
    private func setupConstraints() {
        heightAnchor.constraint(equalToConstant: UIView.dynamicHeight(for: 140)).isActive = true
    }
    
    // MARK: - UITextViewDelegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text == placeholderText {
            clearPlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            showPlaceholder()
        }
    }
    
    // MARK: - Helper Methods
    
    private func clearPlaceholder() {
        text = ""
        textColor = .systemWhite
    }
    
    private func showPlaceholder() {
        text = placeholderText
        textColor = .systemGray2
    }
    
    func getTextContent() -> String {
        return text == placeholderText ? "" : text
    }
    
    // MARK: - Public Method to Set Text Content
    func setTextContent(_ text: String) {
        self.text = text
        textColor = .systemWhite
    }
}
