//
//  CharacterCell.swift
//  AIVoice
//
//  Created by Mac on 1.11.2024.
//

import UIKit
import Kingfisher

final class CharacterCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "CharacterCell"
    
    private lazy var isImageLoaded = false

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemWhite
        label.font = .regularFont(ofSize: 17)
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .unknownColor.withAlphaComponent(0.6)
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.primaryColor1.cgColor
        view.alpha = 0
        return view
    }()
    
    private lazy var overlayImage: UIImageView = {
        let imageView = UIImageView()
        imageView.loadImage(named: "overlayImage")
        return imageView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(activityIndicator)
        overlayView.addSubview(overlayImage)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        
        overlayImage.snp.makeConstraints { make in
            make.center.equalTo(overlayView)
            make.width.equalTo(27)
            make.height.equalTo(30)
        }
    }
    
    private func configureAppearance() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Cell Reset
    private func resetCell() {
        titleLabel.text = nil
        imageView.image = nil
        overlayView.alpha = 0
        activityIndicator.stopAnimating()
        isImageLoaded = false
    }
    
    // MARK: - Configuration
    func configure(with character: Character) {
        titleLabel.text = character.name
        
        if isImageLoaded { return }
        
        activityIndicator.startAnimating()
        loadImage(from: character.imageUrl)
    }
    
    private func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            activityIndicator.stopAnimating()
            return
        }
        
        imageView.kf.setImage(with: imageUrl) { [weak self] _ in
            self?.activityIndicator.stopAnimating()
            self?.isImageLoaded = true
        }
    }
    
    // MARK: - Selection
    func setSelected(_ isSelected: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = isSelected ? 1.0 : 0.0
        }
    }
}
