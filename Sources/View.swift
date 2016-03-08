//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol ComponentDataSource: class {
    func updateComponent(componentView: UIView, with componentTarget: ComponentTarget)
}

public enum ConfigurationUpdatingStrategy {
    case WhenComponentChanged
    case Always
}

extension UIView: ComponentType {
    public func setupCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown style \(style), should implement `handleCustomStyle:` in extension of UIView or its subclass.")
    }
    public func removeCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown style \(style), should implement `removeCustomStyle:` in extension of UIView or its subclass.")
    }
}

extension UIView {
    
    /**
     * Configure component with configuration
     *
     - parameter componentTarget:  configuration
     - parameter dataSource:       data source
     - parameter updatingStrategy: the strategy used to decide if should rebuild a component
     */
    public func configure(componentTarget: ComponentTarget, dataSource: ComponentDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenComponentChanged) {
        if let cell = self as? UICollectionViewCell {
            cell.contentView._configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else if let cell = self as? UITableViewCell {
            cell.contentView._configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else {
            _configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        }
    }

    private func _configure(componentTarget: ComponentTarget, dataSource: ComponentDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenComponentChanged) {

        guard self.dynamicType.isSubclassOfClass(componentTarget.targetClass) else {
            assertionFailure("Component type: \(self.dynamicType) is not compatible with configuration type: \(componentTarget.targetClass)")
            return
        }

        // resolve conf based on item?, indexPath? or others ?

        // call willApply delegate method

        // apply componentTarget
        applyDiffTo(self, newConfiguration:componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)

        // if no error, then:
        self.configuration = componentTarget

//        // update component's value
//        dataSource?.updateComponent(self, with: componentTarget)

        // call didApply delegate method

        // TODO: need to imporve this algo, too expensive and too fragile which based only on name.
        // configure sub components recursively
        for subview in self.subviews {
            if let name = subview.configuration?.name, let components = componentTarget.components {
                for child in components where child.name == name {
                    subview.configure(child, dataSource: dataSource, updatingStrategy: updatingStrategy)
                }
            }
        }
    }
}

extension UIView {

    // TODO: how to handle clean up for reuse
    /*
    func cleanUpForReuse() {
        switch self {
        case let label as UILabel:
            label.text = nil
        case let imageView as UIImageView:
            imageView.image = nil
        default:
            break
        }

        // do clean up
        for case let subview in self.subviews {
            subview.cleanUpForReuse()
        }
    }*/

    public var componentName: String? {
        return configuration?.name
    }

    public func fittingHeight() -> CGFloat {

        // if height resolver is found
        if let computeClosure = configuration?.cellHeightResolver {
            //TODO:  should use children component instead of subview ?
            return computeClosure(childrenHeights: subviews.map { (subview) -> CGFloat in
                    return subview.fittingHeight()
                })
        } else if subviews.isEmpty {
            // leaf component -> dynamic height
            return self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.max)).height
        } else {
            return self.systemLayoutSizeFittingSize(CGSize(width: self.frame.width, height: 0), withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel).height
        }
    }
}


