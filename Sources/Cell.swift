//
//  ReusableCell.swift
//  LeeGo
//
//  Created by Victor WANG on 10/01/16.
//
//

import Foundation
import UIKit

// Cell

extension UICollectionViewCell {

    ///  Helper method used to calculate the fitting height of current cell.
    ///  Call it directly inside UICollectionViewCell.preferredLayoutAttributesFittingAttributes. Ex:
    ///  ```
    ///  override public func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    ///       return fittingHeightLayoutAttributes(layoutAttributes)
    ///  }
    ///  ```
    ///
    ///  - parameter layoutAttributes: layoutAttributes from `UICollectionViewCell.preferredLayoutAttributesFittingAttributes`
    ///
    ///  - returns: UICollectionViewLayoutAttributes instance with fitting height.
    public func fittingHeightLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.frame = layoutAttributes.frame

        // TODO: implement a cache mechanisme
        // if cached, return cached value

        self.setNeedsLayout()
        self.layoutIfNeeded()

        layoutAttributes.frame = {
            var frame = layoutAttributes.frame
            frame.size.height = contentView.fittingHeight()
            return frame
            }()

        // this function get called 4 times everytime
        return layoutAttributes
    }
}

