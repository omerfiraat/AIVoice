//
//  ViewController.swift
//  AIVoice
//
//  Created by Mac on 30.10.2024.
//

import UIKit
import SnapKit

final class LandingVC: BaseVC {
    
    // MARK: - Properties
    
    private lazy var promptTextView = PromptTextView()
    private lazy var pickVoiceLabel = UILabel()
    private lazy var categoryView = CategoryView()
    private lazy var viewModel = LandingVM()
    private var selectedIndexPath: IndexPath?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = calculateItemSize()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        return collectionView
    }()
    
    private lazy var continueButton: GradientButton = {
        let button = GradientButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleColor = .white
        button.backgroundColor = .unknownColor
        button.cornerRadius = 12
        button.titleLabel?.font = .boldFont(ofSize: 17)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomGradientView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlack.withAlphaComponent(0).cgColor, UIColor.systemBlack.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220)
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.isUserInteractionEnabled = false
        return view
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBarTitle()
        setupPickVoiceLabel()
        setupCategoryView()
        setupCollectionView()
        fetchVoicesAndCategories()
        setupBottomGradientView()
        setupContinueButton()
    }

    // MARK: - Data Fetching
    
    private func fetchVoicesAndCategories() {
        viewModel.fetchVoiceAPI { [weak self] in
            self?.fetchCategories()
        }
    }
    
    private func fetchCategories() {
        let fetchedCategories = viewModel.categories
        categoryView.setCategories(fetchedCategories)
        collectionView.reloadData()
    }

    // MARK: - Selection Handling
    
    private func didSelectCategory(_ category: String) {
        viewModel.filterCharacters(by: category)
        selectedIndexPath = nil
        collectionView.reloadData()
        updateContinueButtonState(isEnabled: false)
    }
    
    // MARK: - Button Actions
    
    @objc private func continueButtonTapped() {
        guard let cover = viewModel.selectedCharacter?.name, let prompt = promptTextView.getText() else { return }
        
        if prompt.isEmpty {
            showPromptError()
        } else {
            navigateToAnimationVC(with: prompt, cover: cover)
        }
    }
    
    private func navigateToAnimationVC(with prompt: String, cover: String) {
        let viewController = AnimationVC()
        viewController.generateRequest = GenerateRequest(prompt: prompt, cover: cover)
        viewController.viewModel.selectedCharacter = viewModel.selectedCharacter
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showPromptError() {
        let alert = UIAlertController(title: "Error", message: "Please entry prompt.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UI Setup
    
    private func setupView() {
        view.addSubview(promptTextView)
        
        promptTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            promptTextView.setDynamicHeight(for: 140)
        }
    }
    
    private func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "AI Voice"
        titleLabel.font = UIFont.boldFont(ofSize: 17)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = nil
    }

    private func setupPickVoiceLabel() {
        pickVoiceLabel.text = "Pick a Voice"
        pickVoiceLabel.textColor = .systemWhite
        pickVoiceLabel.font = .boldFont(ofSize: 26)
        view.addSubview(pickVoiceLabel)
        pickVoiceLabel.snp.makeConstraints { make in
            make.top.equalTo(promptTextView.snp.bottom).offset(12)
            make.leading.equalTo(promptTextView)
        }
    }

    private func setupCategoryView() {
        categoryView.delegate = self
        view.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(pickVoiceLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
    }

    private func setupContinueButton() {
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            continueButton.setDynamicHeight(for: 64)

        }
    }
    
    private func setupBottomGradientView() {
        view.addSubview(bottomGradientView)
        bottomGradientView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            bottomGradientView.setDynamicHeight(for: 220)
        }
    }
    
    // MARK: - Layout Calculations

    private func calculateItemSize() -> CGSize {
        let totalWidth = UIScreen.main.bounds.width - 32
        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = (totalWidth - (numberOfItemsPerRow - 1) * 8) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth + 32)
    }

    // MARK: - Button State Management

    private func updateContinueButtonState(isEnabled: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isEnabled {
                self.continueButton.setTitleColor(.white, for: .normal)
                self.continueButton.gradientColors = [.primaryColor1, .primaryColor2]
            } else {
                self.continueButton.setTitleColor(.systemWhite.withAlphaComponent(0.5), for: .normal)
                self.continueButton.gradientColors = nil
                self.continueButton.backgroundColor = .unknownColor
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LandingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CharacterCell = collectionView.dequeue(withType: CharacterCell.self, for: indexPath)
        let voice = viewModel.filteredCharacters[indexPath.row]
        cell.configure(with: voice)
        return cell
    }
}

// MARK: - CategoryViewDelegate
extension LandingVC: CategoryViewDelegate {
    func didTapCategory(_ category: String) {
        didSelectCategory(category)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LandingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateItemSize()
    }
}

// MARK: - UICollectionViewDelegate
extension LandingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            deselectItem(at: indexPath)
            viewModel.selectedCharacter = nil
        } else {
            selectItem(at: indexPath)
            viewModel.selectedCharacter = viewModel.filteredCharacters[indexPath.row]
        }
    }

    
    private func selectItem(at indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CharacterCell {
            previousCell.setSelected(false)
        }
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? CharacterCell {
            currentCell.setSelected(true)
        }
        
        selectedIndexPath = indexPath
        updateContinueButtonState(isEnabled: true)
    }
    
    private func deselectItem(at indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? CharacterCell {
            currentCell.setSelected(false)
        }
        selectedIndexPath = nil
        updateContinueButtonState(isEnabled: false)
    }
}
