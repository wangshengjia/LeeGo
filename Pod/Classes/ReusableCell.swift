//
//  ReusableCell.swift
//  Pods
//
//  Created by Victor WANG on 10/01/16.
//
//

import Foundation

// Cell

extension UITableViewCell {
    public func configure(item: ItemType, configuration: ConfigurationType) {
        self.contentView.configure(item, configuration: configuration)
    }

//    public override func prepareForReuse() {
//        super.prepareForReuse()
//
//        cleanUpForReuse()
//    }
}

extension UICollectionViewCell {
    public func configure(item: ItemType, configuration: ConfigurationType) {
        self.contentView.configure(item, configuration: configuration)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        cleanUpForReuse()
    }
}

//public class ReusableCell: UICollectionViewCell {
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//
//    }
//}

public protocol Comparable {}


