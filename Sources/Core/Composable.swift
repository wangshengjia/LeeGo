//
//  Composable.swift
//  Pods
//
//  Created by Victor WANG on 21/02/16.
//
//

import Foundation

protocol Composable {
    func composite<View where View: UIView, View: BrickDescribable>(bricks: [Brick], to targetView: View, with layout: Layout)
}

extension Composable {
    func composite<View where View: UIView, View: BrickDescribable>(bricks: [Brick], to targetView: View, with layout: Layout) {

        // remove subviews which do not exist anymore in bricks
        for subview in targetView.subviews {
            if let oldBrick = subview.currentBrick where !bricks.contains(oldBrick) {
                subview.removeFromSuperview()
            }
        }

        // filter bricks already exist
        let filteredBricks = bricks.filter { (subBrick) -> Bool in
            if let subbricks = targetView.currentBrick?.bricks where subbricks.contains(subBrick) {
                for subview in targetView.subviews {
                    if let subbrick2 = subview.currentBrick where subbrick2 == subBrick {
                        return false
                    }
                }
            }
            return true
        }

        filteredBricks.forEach { brick in
            var view: UIView? = nil;

            if let nibName = brick.nibName,
                let brickView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView {
                    view = brickView
            } else if let targetClass = brick.targetClass as? UIView.Type {
                view = targetClass.init()
            }

            view?.isRoot = false
            view?.currentBrick = Brick(name: brick.name, targetClass: brick.targetClass, nibName: brick.nibName)
            if let view = view {
                targetView.addSubview(view)
                view.brickDidAwake()
            }
        }

        //TODO: sort brick's subviews to have as same order as bricks
        var viewsDictionary = [String: UIView]()
        for subview in targetView.subviews {
            if let name = subview.currentBrick?.name {
                viewsDictionary[name] = subview
            }
        }

        // Remove constraint with identifier (which means not created by system)
        targetView.removeConstraints(targetView.constraints.filter({ (constraint) -> Bool in
            if constraint.mode == .SubviewsLayout {
                return true
            }
            return false
        }))

        // Layout each view with auto layout visual format language as brick.
        for format in layout.formats {
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: layout.options, metrics: layout.metrics.metrics(), views: viewsDictionary)
            for constraint in constraints {
                constraint.setIdentifier(with: .SubviewsLayout)
                targetView.addConstraint(constraint)
            }
        }
    }
}

