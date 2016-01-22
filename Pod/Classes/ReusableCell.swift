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
        
        // will apply
        let resolvedConfiguration = context.delegate?.configurationWillBeApplied(configuration, toComponent: self, withItem: item, atIndexPath: nil) ?? configuration

        // apply resolved configuration
        contentView.configure(item, configuration: resolvedConfiguration)


        // did apply
        context.delegate?.didApplyConfiguration(configuration, toComponent: self, withItem: item, atIndexPath: nil)
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


public protocol ConfiguratorDelegate {
    
    func configurationWillBeApplied(
        defaultConfig: ConfigurationType,
        toComponent component: ComponentType,
        withItem item: ItemType,
        atIndexPath indexPath: NSIndexPath?) -> ConfigurationType

    func didApplyConfiguration(config: ConfigurationType,
        toComponent component: ComponentType,
        withItem item: ItemType,
        atIndexPath indexPath: NSIndexPath?)

}

//public class ReusableCell: UICollectionViewCell {
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//
//    }
//}

public protocol Comparable {}


