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

extension UICollectionViewCell {
    override public func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes

        var newFrame = attr.frame
        self.frame = newFrame

        self.setNeedsLayout()
        self.layoutIfNeeded()

        let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        newFrame.size.height = desiredHeight
        attr.frame = newFrame
        return attr
    }
}

//public class ReusableCell: UICollectionViewCell {
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//
//    }
//}

public protocol Comparable {}


