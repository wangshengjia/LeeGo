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

//    public override func prepareForReuse() {
//        super.prepareForReuse()
//
//        cleanUpForReuse()
//    }
}

extension UICollectionViewCell {
    
    public override func prepareForReuse() {
        super.prepareForReuse()

        cleanUpForReuse()
    }
}

extension UICollectionViewCell {
    override public func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // if cached, return cached value
        
        // calculate manually

        // calculate auto
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes

        var newFrame = attr.frame
        self.frame = newFrame

        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
        self.layoutIfNeeded()

        let desiredHeight = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        newFrame.size.height = desiredHeight
        attr.frame = newFrame
        return attr
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

