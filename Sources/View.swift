//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol BrickDataSource {
    func updateBrick(componentView: UIView, with Brick: Brick)
}

public enum ConfigurationUpdatingStrategy {
    case WhenBrickChanged
    case Always
}

extension UIView: BrickType {
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
    
    public func configureAs(brick: Brick, dataSource: BrickDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenBrickChanged) {
        if let cell = self as? UICollectionViewCell {
            cell.contentView._configure(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else if let cell = self as? UITableViewCell {
            cell.contentView._configure(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else {
            _configure(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        }
    }

    private func _configure(brick: Brick, dataSource: BrickDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenBrickChanged) {

        guard self.dynamicType.isSubclassOfClass(brick.targetClass) else {
            assertionFailure("Brick type: \(self.dynamicType) is not compatible with configuration type: \(brick.targetClass)")
            return
        }

        // apply Brick
        apply(self, newConfiguration: brick, dataSource: dataSource, updatingStrategy: updatingStrategy)

        // if no error, then:
        self.configuration = brick

        // TODO: need to imporve this algo, too expensive and too fragile which based only on name.
        // configure sub components recursively
        for subview in self.subviews {
            if let name = subview.configuration?.name, let components = brick.components {
                for childBrick in components where childBrick.name == name {
                    subview.configureAs(childBrick, dataSource: dataSource, updatingStrategy: updatingStrategy)
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


