//
//  AppCoordinator.swift
//  AIVoice
//
//  Created by Mac on 30.10.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showMainScreen()
    }

    private func showMainScreen() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.start()
    }
}
