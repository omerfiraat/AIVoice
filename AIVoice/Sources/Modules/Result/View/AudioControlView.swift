//
//  AudioControlView.swift
//  AIVoice
//
//  Created by Mac on 5.11.2024.
//

import UIKit
import SnapKit
import AVFoundation

protocol AudioControlViewDelegate: AnyObject {
    func audioDidFinishPlaying()
}

class AudioControlView: UIView {

    // MARK: - UI Elements
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill")?.withTintColor(.systemBlack, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = .systemWhite
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var timeLabel: UILabel = createLabel()
    private lazy var allTimeLabel: UILabel = createLabel()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .systemWhite
        progressView.trackTintColor = .systemWhite.withAlphaComponent(0.3)
        return progressView
    }()

    // MARK: - Properties
    weak var delegate: AudioControlViewDelegate?
    private var isPlaying = false
    private var audioPlayer: AVPlayer?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(progressView)
        addSubview(playPauseButton)
        addSubview(timeLabel)
        addSubview(allTimeLabel)
    }
    
    private func setupConstraints() {
        progressView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(322)
            make.height.equalTo(2)
        }

        playPauseButton.snp.makeConstraints { make in
            make.leading.equalTo(progressView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(progressView)
            make.width.height.equalTo(56)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressView.snp.leading)
            make.top.equalTo(progressView.snp.bottom).offset(8)
        }

        allTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(8)
            make.trailing.equalTo(progressView.snp.trailing)
        }
    }

    // MARK: - Actions
    @objc private func playPauseButtonTapped() {
        isPlaying.toggle()
        updateButtonTitle()
        if isPlaying {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
    }

    // MARK: - Update Methods
    func updateButtonTitle() {
        let icon = isPlaying ? "pause.fill" : "play.fill"
        let image = UIImage(systemName: icon)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        playPauseButton.setImage(image, for: .normal)
    }
    
    func updateTimeLabel(with time: String) {
        timeLabel.text = time
    }
    
    func isPlayingState() -> Bool {
        return isPlaying
    }

    // MARK: - Audio Playback
    func playAudio(from url: URL) {
        audioPlayer = AVPlayer(url: url)

        // Get the duration of the audio file and update the allTimeLabel
        if let duration = audioPlayer?.currentItem?.asset.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            allTimeLabel.text = formatTime(seconds: totalSeconds)
        }
        
        audioPlayer?.play()
        isPlaying = true
        updateButtonTitle()
        
        addPeriodicTimeObserver()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(audioDidFinish),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: audioPlayer?.currentItem)
    }
    
    @objc private func audioDidFinish() {
        isPlaying = false
        updateButtonTitle()
        
        audioPlayer?.seek(to: .zero)
        progressView.progress = 0.0
        updateTimeLabel(with: "00:00")
        
        delegate?.audioDidFinishPlaying()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Periodic Time Observer
    private func addPeriodicTimeObserver() {
        audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self.audioPlayer?.currentItem?.duration ?? .zero)

            if duration > 0 {
                self.progressView.progress = Float(currentTime / duration)
            }

            self.updateTimeLabel(with: self.formatTime(seconds: currentTime))
        }
    }

    // MARK: - Helper Methods
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.regularFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }

    private func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
