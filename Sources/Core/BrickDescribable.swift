//
//  BrickDescribable.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol BrickDescribable: class, Configurable, Composable {

    func brickDidAwake()
    func configureAs(brick: Brick, dataSource: BrickDataSource?, updatingStrategy: UpdatingStrategy)
    
}

extension BrickDescribable {

    func apply<View where View: UIView, View: BrickDescribable>(newBrick: Brick, to view: View, with dataSource: BrickDataSource? = nil, updatingStrategy: UpdatingStrategy) {

        if shouldRebuild(view.currentBrick, with: newBrick, updatingStrategy: updatingStrategy) {
            applyDiff(with: newBrick, to: view)
        }

        // update brick's value
        dataSource?.update(view, with: newBrick)
    }

    private func applyDiff<View where View: UIView, View: BrickDescribable>(with newBrick: Brick, to view: View) {

        // setup self, only if brick is not initialized from a nib file
        if view.currentBrick?.nibName == nil {
            setup(view, currentStyle: view.currentBrick?.style ?? [], newStyle: newBrick.style ?? [])
        }

        // handle brick's width & height constraint
        applyDimension(of: newBrick, to: view)

        // add & layout sub views
        if let bricks = newBrick.bricks where !bricks.isEmpty, let layout = newBrick.layout {
            composite(bricks, to: view, with: layout)
        }
    }

    private func shouldRebuild(currentBrick: Brick?, with newBrick: Brick, updatingStrategy: UpdatingStrategy) -> Bool {

        var shouldRebuild = (currentBrick == nil)

        switch updatingStrategy {
        case .WhenBrickChanged:
            if let current = currentBrick
                where current.name != newBrick.name
                    || (current.style == nil && current.bricks == nil && current.layout == nil) {
                shouldRebuild = true
            }
        case .Always:
            shouldRebuild = true
        }

        return shouldRebuild
    }

    private func applyDimension<View where View: UIView, View: BrickDescribable>(of newBrick: Brick, to brick: View) {
        if let width = newBrick.width {
            brick.applyConstraint(.Width, constant: width)
        } else {
            brick.unapplyConstraint(.Width)
        }

        if let height = newBrick.height {
            brick.applyConstraint(.Height, constant: height)
        } else {
            brick.unapplyConstraint(.Height)
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

extension BrickDescribable where Self: UIView {

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


