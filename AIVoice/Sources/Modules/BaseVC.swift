//
//  BaseVC.swift
//  AIVoice
//
//  Created by Mac on 2.11.2024.
//

import UIKit

enum LeftButtonType: String {
    case arrow = "navLeft"
    case cancel = "xButton"
    case none
}

enum RightButtonType: String {
    case contextMenu = "threeDots"
    case none
}

protocol BaseVCDelegate: AnyObject {
    func rightButtonTapped()
}

class BaseVC: UIViewController {
    
    var shouldPopToRoot: Bool = false
    var leftButtonType: LeftButtonType = .arrow
    var rightButtonType: RightButtonType = .none
    weak var delegate: BaseVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        setupNavigationBar()
        setupViewAppearance()
    }

    // MARK: - Navigation Bar Setup

    private func setupNavigationBar() {
        setupLeftButton()
        setupRightButton()
        
        // Set tint color for the navigation bar items
        navigationController?.navigationBar.tintColor = .white
        
        // Set the title text color to white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldFont(ofSize: 17)
        ]
    }
    
    private func setupLeftButton() {
        guard leftButtonType != .none else {
            navigationItem.leftBarButtonItem = nil
            return
        }
        
        let backButtonImageName = leftButtonType.rawValue
        guard let backButtonImage = UIImage(named: backButtonImageName)?.withRenderingMode(.alwaysTemplate) else {
            print("Left button image not found: \(backButtonImageName)")
            return
        }
        
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.title = ""
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupRightButton() {
        guard rightButtonType != .none else {
            navigationItem.rightBarButtonItem = nil
            return
        }
        
        let rightButtonImageName = rightButtonType.rawValue
        guard let rightButtonImage = UIImage(named: rightButtonImageName)?.withRenderingMode(.alwaysTemplate) else {
            print("Right button image not found: \(rightButtonImageName)")
            return
        }
        
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(rightButtonTapped))
        rightButton.title = ""
        
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc private func backButtonTapped() {
        if shouldPopToRoot {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func rightButtonTapped() {
        delegate?.rightButtonTapped()
    }

    // MARK: - Set Title
    func setTitle(_ title: String?) {
        self.navigationItem.title = title
    }

    // MARK: - View Appearance Setup

    private func setupViewAppearance() {
        view.backgroundColor = .systemBlack
    }
}

extension UIViewController {
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
