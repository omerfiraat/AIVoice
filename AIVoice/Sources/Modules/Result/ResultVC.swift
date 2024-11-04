//
//  ResultVC.swift
//  AIVoice
//
//  Created by Mac on 2.11.2024.
//

import UIKit
import AVFoundation

class ResultVC: BaseVC {
    var audioURL: URL?
    private var audioPlayer: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPopToRoot = true
        view.backgroundColor = .white

        if let url = audioURL {
            playAudio(from: url)
        }
    }

    private func playAudio(from url: URL) {
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }
}
