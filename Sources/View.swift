//
//  View.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

/// This protocol represents the data model object of Brick.
public protocol BrickDataSource {
    ///  Delegate method used to update target view's data. Ex:
    ///  ```
    ///  func update(targetView: UIView, with brick: Brick) {
    ///    switch targetView {
    ///    case let textView as UITextView where brick == Twitter.tweetText:
    ///    textView.text = text
    ///    case let label as UILabel where brick == Twitter.username:
    ///    label.text = userName
    ///    case let avatar as UIImageView where brick == Twitter.avatar:
    ///    avatar.image = UIImage...
    ///    }
    ///  }
    ///  ```
    ///
    ///  This method get called after the appearance applied and sub-bricks compisted.
    ///
    ///  - Note: You could but not be suggested to change the appearance of the view in this method usually.
    ///
    func update(targetView: UIView, with brick: Brick)
}

///  Specific a strategy to determine what to do
///  when configure the same target view with changed/different bricks.
///  You could specify this strategy when configure a target view as a given brick. Ex:
///
/// ```
/// cell.lg_configureAs(brick, dataSource: elements[indexPath.item], updatingStrategy: .Always)
/// ```
///
///  - WhenBrickChanged: If the new brick has the same name as the configured one, the target view will ignored the new brick.
///  - Always: The target view will get applied anyway
public enum UpdatingStrategy {
    case WhenBrickChanged
    case Always
}

extension UIView: BrickDescribable {
    ///  A delegate method get called once a target view get created
    ///  You can override this method. You should call `super` implementation when override.
    public func lg_brickDidAwake() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    ///  A delegate method used to setup a custom style to a target view.
    ///
    ///  - Note: You should always override and implement this method if you have a custom style
    ///
    ///  - parameter style: custom style specified in Appearance.custom
    public func lg_setupCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown style \(style), should implement `lg_setupCustomStyle:` in extension of UIView or its subclass.")
    }

    ///  A delegate method used to remove a custom style from a target view.
    ///
    ///  - Note: You should always override and implement this method if you have a custom style
    ///
    ///  - parameter style: custom style specified in Appearance.custom
    public func lg_removeCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown style \(style), should implement `lg_removeCustomStyle:` in extension of UIView or its subclass.")
    }

    ///  This method will go through the whole view hierarchy and 
    ///  retrieve the reference of target view which have the given outlet key.
    ///
    ///  - Note: Once found the view, you can keep the target view as a property with a weak reference,
    ///  just as you usually do for the IBOutlet property
    ///  - parameter key: outlet key of `brick`
    ///
    ///  - returns: target view found
    public func lg_viewForOutletKey(key: String) -> UIView? {
        if let currentKey = currentBrick?.LGOutletKey where currentKey == key {
            return self
        }

        for subview in self.subviews {
            if let view = subview.lg_viewForOutletKey(key) {
                return view
            }
        }

        return nil
    }

    ///  Configure `self` as the given brick, with data source and updating strategy.
    ///
    ///  - parameter brick:            A `Brick` instance. The target class of brick should as same as `self.dynamicType`.
    ///  - parameter dataSource:       The data source object which implement the `BrickDataSource` protocol.
    ///  - parameter updatingStrategy: The stragegy which determine what to do when brick changed with the same target view.
    public func lg_configureAs(brick: Brick, dataSource: BrickDataSource? = nil, updatingStrategy: UpdatingStrategy = .WhenBrickChanged) {
        if let cell = self as? UICollectionViewCell {
            cell.contentView._configureAs(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else if let cell = self as? UITableViewCell {
            cell.contentView._configureAs(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else {
            _configureAs(brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        }
    }
}

extension UIView {
    
    internal var lg_brickName: String? {
        return currentBrick?.name
    }

    internal func lg_fittingHeight() -> CGFloat {

        // if height resolver is found
        if let computeClosure = currentBrick?.heightResolver {
            let fittingWidth = self.frame.width
            let childrenHeights = subviews.map { (subview) -> CGFloat in
                return subview.lg_fittingHeight()
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
                    subview.lg_configureAs(childBrick, dataSource: dataSource, updatingStrategy: updatingStrategy)
                }
            }
        }
    }
}


