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

extension UITableViewCell {

//    public override func prepareForReuse() {
//        super.prepareForReuse()
//
//        cleanUpForReuse()
//    }
}

extension UICollectionViewCell {
    
    public override func prepareForReuse() {
        super.prepareForReuse()

        // cleanUpForReuse()
    }
}

extension UICollectionViewCell {
    override public func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

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

        let desiredHeight = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        newFrame.size.height = desiredHeight
        attr.frame = newFrame

        // this function get called 4 times everytime
        return attr
    }
}

extension UITextView {
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.max)).height)
    }
}

//
//public protocol ConfiguratorDelegate {
//
//    func willApply<Component: UIView>(
//        with Style: [Appearance],
//        toComponent component: Component,
//        withItem item: ItemType,
//        atIndexPath indexPath: NSIndexPath?) -> [Appearance]
//
//    func willComposite<Component: UIView>(with
//        components: [ComponentTarget],
//        toComponent component: Component,
//        using layout: Layout,
//        withItem item: ItemType,
//        atIndexPath indexPath: NSIndexPath?)
//
//    func willApply<Component: UIView>(with
//        componentTarget: ComponentTarget,
//        toComponent component: Component,
//        withItem item: ItemType,
//        atIndexPath indexPath: NSIndexPath?) -> ComponentTarget
//
//    func didApply<Component: UIView>(with componentTarget: ComponentTarget,
//        toComponent component: Component,
//        withItem item: ItemType,
//        atIndexPath indexPath: NSIndexPath?)
//
//}

