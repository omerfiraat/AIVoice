//
//  AnimationVC.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import UIKit
import AVFoundation
import SnapKit

final class AnimationVC: BaseVC {

    // MARK: - Properties

    var generateRequest: GenerateRequest?
    lazy var viewModel = AnimationVM()
    private let animationView = AnimationView()
    var audioURL: URL?
    
    // MARK: - UI Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemWhite
        label.font = .boldFont(ofSize: 34)
        label.text = "Generating"
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemWhite
        label.font = .regularFont(ofSize: 17)
        label.numberOfLines = 0
        label.text = "It may take up to few minutes for you to receive an AI-generated speech. You can find your voice record in Library."
        return label
    }()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        leftButtonType = .cancel
        super.viewDidLoad()
        setupView()
        startAnimationAndFetchAudio()
    }
    
    // MARK: - Configuration

    func configure(with request: GenerateRequest) {
        self.generateRequest = request
    }
    
    // MARK: - Setup Methods

    private func setupView() {
        setupAnimationView()
        setupLabels()
    }

    private func setupAnimationView() {
        animationView.backgroundColor = .clear
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.centerX.equalToSuperview()
            animationView.setDynamicWidth(for: 400)
            animationView.setDynamicHeight(for: 400)
        }
    }

    private func setupLabels() {
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            titleLabel.setDynamicWidth(for: 283)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            detailLabel.setDynamicWidth(for: 283)
        }
    }

    // MARK: - Animation and Network Methods

    private func startAnimationAndFetchAudio() {
        animationView.startAnimating()
        
        /// For simulate like a generation.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.fetchGeneratedAudio()
        }
    }

    private func fetchGeneratedAudio() {
        guard let request = generateRequest else { return }
        
        viewModel.generateApi(request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleSuccess(response)
            case .failure(let error):
                self?.showAlert(title: "Generate Failed", message: "\(error.localizedDescription)", buttonTitle: "OK") {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }

    private func handleSuccess(_ response: GenerateResponse) {
        let urlString = response.resultUrl
        guard let audioURL = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        self.audioURL = audioURL
        let nextVC = ResultVC()
        nextVC.viewModel.audioURL = audioURL
        nextVC.character = viewModel.selectedCharacter
        nextVC.generateRequest = generateRequest
        navigationController?.pushViewController(nextVC, animated: true)
        animationView.stopAnimating()
    }
}
