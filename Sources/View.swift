//
//  View.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol BrickDataSource {
    func update(targetView: UIView, with brick: Brick)
}

public enum UpdatingStrategy {
    case WhenBrickChanged
    case Always
}

extension UIView: BrickDescribable {
    public func brickDidAwake() {
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
    
    public func configureAs(brick: Brick, dataSource: BrickDataSource? = nil, updatingStrategy: UpdatingStrategy = .WhenBrickChanged) {
        if let cell = self as? UICollectionViewCell {
            cell.contentView._configureAs(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else if let cell = self as? UITableViewCell {
            cell.contentView._configureAs(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else {
            _configureAs(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        }
    }

    private func _configureAs(brick: Brick, dataSource: BrickDataSource? = nil, updatingStrategy: UpdatingStrategy = .WhenBrickChanged) {

        guard self.dynamicType.isSubclassOfClass(brick.targetClass) else {
            assertionFailure("Brick type: \(self.dynamicType) is not compatible with configuration type: \(brick.targetClass)")
            return
        }

        // apply Brick
        apply(brick, to: self, with: dataSource, updatingStrategy: updatingStrategy)
        self.currentBrick = brick

        // configure sub bricks recursively
        for subview in self.subviews {
            if let name = subview.currentBrick?.name, let bricks = brick.bricks {
                for childBrick in bricks where childBrick.name == name {
                    subview.configureAs(childBrick, dataSource: dataSource, updatingStrategy: updatingStrategy)
                }
            }
        }
    }
}

extension UIView {

    public func viewForOutletKey(key: String) -> UIView? {
        if let currentKey = currentBrick?.LGOutletKey where currentKey == key {
            return self
        }

        for subview in self.subviews {
            if let view = subview.viewForOutletKey(key) {
                return view
            }
        }
        
        return nil
    }
}

extension UIView {
    
    internal var brickName: String? {
        return currentBrick?.name
    }

    internal func fittingHeight() -> CGFloat {

        // if height resolver is found
        if let computeClosure = currentBrick?.heightResolver {
            let fittingWidth = self.frame.width
            let childrenHeights = subviews.map { (subview) -> CGFloat in
                return subview.fittingHeight()
            }
            let metrics = currentBrick?.layout?.metrics ?? LayoutMetrics()

            return computeClosure(fittingWidth: fittingWidth, childrenHeights: childrenHeights, metrics: metrics)
        } else if subviews.isEmpty {
            // leaf brick -> dynamic height
            return self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.max)).height
        } else {
            return self.systemLayoutSizeFittingSize(CGSize(width: self.frame.width, height: 0), withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel).height
        }
    }
}


