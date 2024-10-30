//
//  Coordinator.swift
//  AIVoice
//
//  Created by Mac on 30.10.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
