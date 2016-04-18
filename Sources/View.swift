//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol ComponentDataSource {
    func updateComponent(componentView: UIView, with componentTarget: ComponentTarget)
}

public enum ConfigurationUpdatingStrategy {
    case WhenComponentChanged
    case Always
}

extension UIView: ComponentType {
    public func componentDidAwake() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

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

        // apply componentTarget
        apply(self, newConfiguration:componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)

        // if no error, then:
        self.configuration = componentTarget

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

    public func viewForOutletKey(key: String) -> UIView? {
        if let currentKey = self.configuration?.LGOutletKey where currentKey == key {
            return self
        }

        for subview in self.subviews {
            if let view = subview.viewForOutletKey(key) {
                return view
            }
        }
        
        return nil
    }

    internal var componentName: String? {
        return configuration?.name
    }

    internal func fittingHeight() -> CGFloat {

        // if height resolver is found
        if let computeClosure = configuration?.heightResolver {
            //TODO:  should use children component instead of subview ?
            let fittingWidth = self.frame.width
            let childrenHeights = subviews.map { (subview) -> CGFloat in
                return subview.fittingHeight()
            }
            let metrics = configuration?.layout?.metrics ?? LayoutMetrics()

            return computeClosure(fittingWidth: fittingWidth, childrenHeights: childrenHeights, metrics: metrics)
        } else if subviews.isEmpty {
            // leaf component -> dynamic height
            return self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.max)).height
        } else {
            return self.systemLayoutSizeFittingSize(CGSize(width: self.frame.width, height: 0), withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel).height
        }
    }
}


