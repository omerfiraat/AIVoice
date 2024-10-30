//
//  MainCoordinator.swift
//  AIVoice
//
//  Created by Mac on 30.10.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewController = ViewController()
        navigationController.pushViewController(mainViewController, animated: true)
    }
}

