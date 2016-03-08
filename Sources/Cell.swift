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

        // super.preferredLayoutAttributesFittingAttributes()
        self.frame = layoutAttributes.frame

        // calculate manually
        // calculate auto

        layoutAttributes.frame = {
            var frame = layoutAttributes.frame
            frame.size.height = contentView.fittingHeight()
            return frame
        }()

        // this function get called 4 times everytime
        return layoutAttributes
    }
}

