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
    func update(_ targetView: UIView, with brick: Brick)
}

public protocol CustomStyleConfigurable {
    func lg_apply(customStyle style: [String: Any])
    func lg_unapply(customStyle style: [String: Any])
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
    case whenBrickChanged
    case always
}

extension UIView: BrickDescribable {
    ///  A delegate method get called once a target view get created
    ///  You can override this method. You should call `super` implementation when override.
    public func lg_brickDidAwake() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    ///  This method will go through the whole view hierarchy and 
    ///  retrieve the reference of target view which have the given outlet key.
    ///
    ///  - Note: Once found the view, you can keep the target view as a property with a weak reference,
    ///  just as you usually do for the IBOutlet property
    ///  - parameter key: outlet key of `brick`
    ///
    ///  - returns: target view found
    public func lg_viewForOutletKey(_ key: String) -> UIView? {
        if let currentKey = currentBrick?.LGOutletKey, currentKey == key {
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
    public func lg_configure(as brick: Brick, dataSource: BrickDataSource? = nil, updatingStrategy: UpdatingStrategy = .whenBrickChanged) {
        if let cell = self as? UICollectionViewCell {
            cell.contentView._configure(as: brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else if let cell = self as? UITableViewCell {
            cell.contentView._configure(as: brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else {
            _configure(as: brick, dataSource: dataSource, updatingStrategy: updatingStrategy)
        }
    }
}

extension UIView {
    
    
    /// This view's relationship to a `Brick` (if has one)
    public var lg_brickName: String? {
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

            return computeClosure(_: fittingWidth, childrenHeights, metrics)
        } else if subviews.isEmpty {
            // leaf brick -> dynamic height
            return self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        } else {
            return self.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: 0), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel).height
        }
    }

    fileprivate func _configure(as brick: Brick, dataSource: BrickDataSource? = nil, updatingStrategy: UpdatingStrategy = .whenBrickChanged) {

        guard type(of: self).isSubclass(of: brick.targetClass) else {
            assertionFailure("Brick type: \(type(of: self)) is not compatible with configuration type: \(brick.targetClass)")
            return
        }

        // apply Brick
        apply(brick, to: self, with: dataSource, updatingStrategy: updatingStrategy)
        self.currentBrick = brick

        // configure sub bricks recursively
        for subview in self.subviews {
            if let name = subview.currentBrick?.name, let bricks = brick.childBricks {
                for childBrick in bricks where childBrick.name == name {
                    subview.lg_configure(as:childBrick, dataSource: dataSource, updatingStrategy: updatingStrategy)
                }
            }
        }
    }
}


