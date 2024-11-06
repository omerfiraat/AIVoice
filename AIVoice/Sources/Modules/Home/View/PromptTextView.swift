//
//  PromptTextView.swift
//  AIVoice
//
//  Created by Mac on 31.10.2024.
//

import UIKit
import SnapKit

final class PromptTextView: UIView, UITextViewDelegate {
    
    // MARK: - Properties
    
    private let placeholderText = "Write a text and let AI turn it into a speech with the voice of your favorite character"
    private var isActionButtonTapped = false
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.regularFont(ofSize: 17)
        textView.textColor = .systemWhite2
        textView.backgroundColor = .systemDark
        textView.layer.cornerRadius = 12
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.isEditable = true
        return textView
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.primaryColor1, for: .normal)
        button.titleLabel?.font = UIFont.boldFont(ofSize: 15)
        button.setUnderlinedText("Get inspiration")
        return button
    }()
    
    private let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.loadImage(named: "inspirationImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        return button
    }()
    
    private let cancelImage: UIImageView = {
        let image = UIImageView()
        image.loadImage(named: "xButton")
        image.isHidden = true
        return image
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods

    private func setupView() {
        setupTextView()
        setupButtons()
        setupImageViews()
        setupPlaceholder()
        setupDelegates()
    }
    
    private func setupTextView() {
        addSubview(textView)
        textView.textContainer.maximumNumberOfLines = 3
        textView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func setupButtons() {
        addSubview(actionButton)
        addSubview(cancelButton)
        
        actionButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-7)
            make.width.equalTo(109)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(textView.snp.trailing).offset(-20)
            make.centerY.equalTo(actionButton)
            make.width.height.equalTo(20)
        }
    }
    
    private func setupImageViews() {
        addSubview(actionImageView)
        actionImageView.snp.makeConstraints { make in
            make.left.equalTo(actionButton.snp.right).offset(3)
            make.centerY.equalTo(actionButton)
            make.width.equalTo(13.75)
            make.height.equalTo(17.5)
        }
        
        addSubview(cancelImage)
        
        cancelImage.snp.makeConstraints { make in
            make.center.equalTo(cancelButton)
            make.width.height.equalTo(8)
        }
    }
    
    private func setupPlaceholder() {
        textView.text = placeholderText
        textView.textColor = .systemWhite2
        cancelButton.isHidden = true
        cancelImage.isHidden = true
    }
    
    private func setupDelegates() {
        textView.delegate = self
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UITextViewDelegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            clearPlaceholder()
        }
        updateCancelButtonVisibility()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            showPlaceholder()
        }
        updateCancelButtonVisibility()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCancelButtonVisibility()
    }
    
    // MARK: - Helper Methods
    
    private func clearPlaceholder() {
        textView.text = ""
        textView.textColor = .systemWhite
    }
    
    private func showPlaceholder() {
        textView.text = placeholderText
        textView.textColor = .systemWhite2
    }
    
    private func updateCancelButtonVisibility() {
        let isTextEmpty = textView.text.isEmpty || textView.text == placeholderText
        cancelButton.isHidden = isTextEmpty
        cancelImage.isHidden = isTextEmpty
    }
    
    // MARK: - Button Actions

    @objc private func actionButtonTapped() {
        guard !isActionButtonTapped else { return }
        isActionButtonTapped = true
        cancelButton.isHidden = true
        setRandomQuote()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isActionButtonTapped = false
        }
    }

    @objc private func cancelButtonTapped() {
        clearTextView()
        cancelButton.isHidden = true
        cancelImage.isHidden = true
        textView.resignFirstResponder()
    }
    
    private func clearTextView() {
        textView.text = ""
        textView.textColor = .systemWhite2
        showPlaceholder()
        updateCancelButtonVisibility()
    }
    
    // MARK: - Public Methods

    func setRandomQuote() {
        let randomIndex = Int.random(in: 0..<Inspirations.quotes.count)
        textView.text = Inspirations.quotes[randomIndex]
        textView.textColor = .systemWhite
        updateCancelButtonVisibility()
    }
    
    func getText() -> String? {
         return textView.text == placeholderText ? "" : textView.text
     }
    
    func setTextViewText(to text: String) {
        textView.text = text
        textView.textColor = .systemWhite
        updateCancelButtonVisibility()
    }
    
    func hideActionAndCancelComponents() {
        actionButton.isHidden = true
        actionImageView.isHidden = true
        cancelButton.isHidden = true
        cancelImage.isHidden = true
        
        self.isUserInteractionEnabled = false
    }

}
