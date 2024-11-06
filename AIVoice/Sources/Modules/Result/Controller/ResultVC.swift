//
//  ResultVC.swift
//  AIVoice
//
//  Created by Mac on 2.11.2024.
//

import UIKit
import Kingfisher
import SnapKit
import MobileCoreServices

final class ResultVC: BaseVC, BaseVCDelegate, AudioControlViewDelegate, UIDocumentPickerDelegate {

    // MARK: - Properties
    private var isLoopingEnabled: Bool = false
    var generateRequest: GenerateRequest?
    var character: Character?
    
    private var isDropdownVisible: Bool = false
    private var dropdownView: DropdownView!

    private lazy var promptTextView = PromptTextView()
    private lazy var textLabel: UILabel = createLabel(text: "Text", fontSize: 27, color: .systemWhite)
    private lazy var imageView: UIImageView = createImageView()
    private lazy var loopButton: UIButton = createLoopButton()
    private lazy var downloadButton: GradientButton = createDownloadButton()
    private lazy var audioControlView: AudioControlView = createAudioControlView()
    private lazy var blurEffectView: UIVisualEffectView = createBlurEffectView()
    lazy var viewModel = ResultVM()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        setupNavigationBar()
        super.viewDidLoad()
        setupUI()
        loadImage()
        setTitle(generateRequest?.cover)

        setupViewModelBindings()
    }

    // MARK: - Setup Methods
    private func setupNavigationBar() {
        leftButtonType = .arrow
        rightButtonType = .contextMenu
        shouldPopToRoot = true
        delegate = self
    }

    private func setupUI() {
        setupImageView()
        setupAudioControlView()
        setupLoopButton()
        configureLabel()
        setupDropdownView()
    }

    private func setupImageView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(122)
            imageView.setDynamicWidth(for: 398)
            imageView.setDynamicHeight(for: 398)
        }
    }

    private func setupAudioControlView() {
        view.addSubview(audioControlView)
        audioControlView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
        
        if let url = viewModel.audioURL {
            audioControlView.playAudio(from: url)
        }
    }

    private func setupLoopButton() {
        imageView.addSubview(loopButton)
        loopButton.insertSubview(blurEffectView, at: 0)
        
        loopButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(98)
            make.height.equalTo(40)
        }

        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        updateLoopButtonAppearance(isSelected: false)
    }

    private func configureLabel() {
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(audioControlView.snp.bottom).offset(24)
            make.leading.equalTo(audioControlView)
        }
        
        view.addSubview(promptTextView)
        promptTextView.setTextViewText(to: self.generateRequest?.prompt ?? "")
        promptTextView.hideActionAndCancelComponents()
        promptTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            promptTextView.setDynamicHeight(for: 130)
        }
        
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(promptTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            downloadButton.setDynamicHeight(for: 64)
        }
    }
    
    private func setupDropdownView() {
        dropdownView = DropdownView()
        dropdownView.addButton(title: "Share", image: UIImage(named: "shareIcon"), action: #selector(shareTapped), target: self)
        dropdownView.addButton(title: "Copy Text", image: UIImage(named: "copyIcon"), action: #selector(copyTextTapped), target: self)
    }

    private func setupViewModelBindings() {
        viewModel.onCopyTextSuccess = { [weak self] in
            self?.showCopiedAlert()
        }
        viewModel.onDownloadSuccess = { [weak self] url in
            self?.showSaveDocumentPicker(at: url)
        }
    }

    private func loadImage() {
        guard let imageUrlString = character?.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            print("Character image URL is nil or invalid.")
            return
        }
        
        imageView.kf.setImage(with: imageUrl) { result in
            switch result {
            case .success(let value):
                print("Image loaded successfully: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }

    // MARK: - Actions
    @objc private func loopButtonTapped() {
        loopButton.isSelected.toggle()
        updateLoopButtonAppearance(isSelected: loopButton.isSelected)
    }

    private func updateLoopButtonAppearance(isSelected: Bool) {
        loopButton.backgroundColor = UIColor.primaryColor1.withAlphaComponent(0.3)
        loopButton.layer.borderColor = isSelected ? UIColor.primaryColor1.cgColor : UIColor.clear.cgColor
        loopButton.layer.borderWidth = isSelected ? 1 : 0
        isLoopingEnabled = isSelected

        let titleColor: UIColor = isSelected ? .systemWhite : UIColor.systemWhite.withAlphaComponent(0.7)
        loopButton.setTitleColor(titleColor, for: .normal)
        loopButton.tintColor = titleColor

        if let image = UIImage(named: "loopImage")?.withRenderingMode(.alwaysTemplate) {
            loopButton.setImage(image, for: .normal)
        }

        blurEffectView.alpha = 0.5
    }

    @objc private func copyTextTapped() {
        guard let textToCopy = promptTextView.getText() else {
            return showAlert(title: "Copy Failed", message: "Failed to copy text.")
        }
        viewModel.copyText(from: textToCopy)
        dropdownView.hide()
    }

    @objc private func shareTapped() {
        if let audioURL = viewModel.share() {
            let activityViewController = UIActivityViewController(activityItems: [audioURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
        dropdownView.hide()
    }

    // MARK: - Alerts
    private func showCopiedAlert() {
        showAlert(title: "Copied!", message: "The text has been copied to your clipboard.") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            }
        }
    }

    private func showDownloadSuccessAlert() {
        showAlert(title: "Downloaded!", message: "The audio file has been downloaded.") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            }
        }
    }

    // MARK: - AudioControlViewDelegate
    func audioDidFinishPlaying() {
        if isLoopingEnabled, let url = viewModel.audioURL {
            audioControlView.playAudio(from: url)
        }
    }

    // MARK: - Button Actions
    func rightButtonTapped() {
        isDropdownVisible.toggle()
        if isDropdownVisible { 
            dropdownView.show(in: view, at: CGPoint(x: 16, y: 100))
        } else {
            dropdownView.hide()
        }
    }
    
    @objc private func downloadMP3() {
        viewModel.downloadMP3()
    }

    // MARK: - UIDocumentPickerDelegate Methods
    private func showSaveDocumentPicker(at url: URL) {
        DispatchQueue.main.async {
            let documentPicker = UIDocumentPickerViewController(url: url, in: .moveToService)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker, animated: true)
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Handle the selected documents if necessary
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle cancellation if necessary
    }
}


// MARK: - Private UI Creation Methods
private extension ResultVC {
    func createLabel(text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldFont(ofSize: fontSize)
        label.textColor = color
        return label
    }

    func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }

    func createLoopButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Loop", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        let titleColor = UIColor.white.withAlphaComponent(0.7)
        button.setTitleColor(titleColor, for: .normal)
        button.tintColor = titleColor
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "loopImage")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(loopButtonTapped), for: .touchUpInside)
        return button
    }

    func createDownloadButton() -> GradientButton {
        let button = GradientButton(type: .system)
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.gradientColors = [.primaryColor1, .primaryColor2]
        button.cornerRadius = 12
        button.titleLabel?.font = .boldFont(ofSize: 17)
        button.addTarget(self, action: #selector(downloadMP3), for: .touchUpInside)
        return button
    }

    func createAudioControlView() -> AudioControlView {
        let controlView = AudioControlView()
        controlView.delegate = self
        return controlView
    }

    func createBlurEffectView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.layer.cornerRadius = 8
        effectView.clipsToBounds = true
        effectView.isUserInteractionEnabled = false
        return effectView
    }
}
