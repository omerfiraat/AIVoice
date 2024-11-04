//
//  BaseVC.swift
//  AIVoice
//
//  Created by Mac on 2.11.2024.
//

import UIKit

class BaseVC: UIViewController {
    
    var shouldPopToRoot: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        setupNavigationBar()
        setupViewAppearance()
    }

    // MARK: - Navigation Bar Setup

    private func setupNavigationBar() {
        let backButtonImage = UIImage(named: "xButton")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.title = ""
        
        navigationItem.leftBarButtonItem = backButton
        
        navigationController?.navigationBar.tintColor = .white
    }

    @objc private func backButtonTapped() {
        if shouldPopToRoot {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - View Appearance Setup

    private func setupViewAppearance() {
        view.backgroundColor = .systemBlack
    }
}

extension UIViewController {
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
