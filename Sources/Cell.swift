//
//  ReusableCell.swift
//  Pods
//
//  Created by Victor WANG on 10/01/16.
//
//

import Foundation
import UIKit

// Cell

extension UICollectionViewCell {
    override public func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        // TODO: improve scroll performance
        // return layoutAttributes

        // if cached, return cached value
        
        // calculate manually

        // calculate auto
        let attr = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)

        attr.frame = layoutAttributes.frame
        var newFrame = attr.frame
        self.frame = newFrame

        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
        self.layoutIfNeeded()

        let desiredHeight = self.contentView.systemLayoutSizeFittingSize(CGSize(width: newFrame.width, height: 0), withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel).height
        newFrame.size.height = desiredHeight
        attr.frame = newFrame

        // this function get called 4 times everytime
        return attr
    }
}

