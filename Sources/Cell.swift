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

    public func fittingHeightLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.frame = layoutAttributes.frame

        // TODO: implement a cache mechanisme
        // if cached, return cached value

        // Need a layout action right now (based on current cell's height) to have correct width
        // TODO: is this cost expensive? is this necessary?
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

