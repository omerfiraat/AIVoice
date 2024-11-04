//
//  CollectionViewExtensions.swift
//  AIVoice
//
//  Created by Mac on 4.11.2024.
//

import UIKit

extension UICollectionView {
    func dequeue<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: type))")
        }
        return cell
    }
}
