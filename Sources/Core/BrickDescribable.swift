//
//  BrickDescribable.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol BrickDescribable: class, Configurable, Composable {

    func lg_brickDidAwake()
    func lg_configureAs(_ brick: Brick, dataSource: BrickDataSource?, updatingStrategy: UpdatingStrategy)
    
}

extension BrickDescribable {

    internal func apply<View>(_ newBrick: Brick, to view: View, with dataSource: BrickDataSource? = nil, updatingStrategy: UpdatingStrategy) where View: UIView, View: BrickDescribable {

        if shouldRebuild(view.currentBrick, with: newBrick, updatingStrategy: updatingStrategy) {
            applyDiff(with: newBrick, to: view)
        }

        // update brick's value
        dataSource?.update(view, with: newBrick)
    }
}

extension BrickDescribable {
    
    fileprivate func applyDiff<View>(with newBrick: Brick, to view: View) where View: UIView, View: BrickDescribable {

        // setup self, only if brick is not initialized from a nib file
        if view.currentBrick?.nibName == nil {
            setup(view, currentStyle: view.currentBrick?.style ?? [], newStyle: newBrick.style ?? [])
        }

        // handle brick's width & height constraint
        applyDimension(of: newBrick, to: view)

        // add & layout sub views
        if let bricks = newBrick.bricks, !bricks.isEmpty, let layout = newBrick.layout {
            composite(bricks, to: view, with: layout)
        }
    }

    fileprivate func shouldRebuild(_ currentBrick: Brick?, with newBrick: Brick, updatingStrategy: UpdatingStrategy) -> Bool {

        var shouldRebuild = (currentBrick == nil)

        switch updatingStrategy {
        case .whenBrickChanged:
            if let current = currentBrick,
              current.name != newBrick.name
                    || (current.style == nil && current.bricks == nil && current.layout == nil) {
                shouldRebuild = true
            }
        case .always:
            shouldRebuild = true
        }

        return shouldRebuild
    }

    private func applyDimension<View>(of newBrick: Brick, to brick: View) where View: UIView, View: BrickDescribable {
        if let width = newBrick.width {
            brick.lg_applyConstraint(.width, constant: width)
        } else {
            brick.unapplyConstraint(.width)
        }

        if let height = newBrick.height {
            brick.lg_applyConstraint(.height, constant: height)
        } else {
            brick.unapplyConstraint(.height)
        }
    }
}


// MARK: Brick Context

private final class BrickContext {
    var brick: Brick?
    var isRoot = true
    var attributesArray: [Attributes] = []
}

private struct AssociatedKeys {
    static var BrickContextAssociatedKey = "BrickContext_AssociatedKey"
}

extension UIView {

    private var context: BrickContext {
        get {
            if let context = objc_getAssociatedObject(self, &AssociatedKeys.BrickContextAssociatedKey) as? BrickContext {
                return context
            } else {
                let context = BrickContext()
                objc_setAssociatedObject(self, &AssociatedKeys.BrickContextAssociatedKey, context as BrickContext?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return context
            }
        }
    }

    internal var currentBrick: Brick? {
        get {
            return context.brick
        }
        set {
            context.brick = newValue
        }
    }

    internal var isRoot: Bool {
        get {
            return context.isRoot
        }
        set {
            context.isRoot = newValue
        }
    }

    internal var attributesArray: [Attributes] {
        get {
            return context.attributesArray
        }
        set {
            context.attributesArray = newValue
        }
    }

}


