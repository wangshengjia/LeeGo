//
//  Composable.swift
//  LeeGo
//
//  Created by Victor WANG on 21/02/16.
//
//

import Foundation

protocol Composable {
    func composite<View>(_ bricks: [Brick], to targetView: View, with layout: Layout) where View: UIView, View: BrickDescribable
}

extension Composable {
    internal func composite<View>(_ bricks: [Brick], to targetView: View, with layout: Layout) where View: UIView, View: BrickDescribable {

        // remove subviews which do not exist anymore in bricks
        for subview in targetView.subviews {
            if let oldBrick = subview.currentBrick, !bricks.contains(oldBrick) {
                subview.removeFromSuperview()
            }
        }

        // filter bricks already exist
        let filteredBricks = bricks.filter { (subBrick) -> Bool in
            if let subbricks = targetView.currentBrick?.bricks, subbricks.contains(subBrick) {
                for subview in targetView.subviews {
                    if let subbrick2 = subview.currentBrick, subbrick2 == subBrick {
                        return false
                    }
                }
            }
            return true
        }

        filteredBricks.forEach { brick in
            var view: UIView? = nil;

            if let nibName = brick.nibName,
                let brickView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView {
                    view = brickView
            } else if let targetClass = brick.targetClass as? UIView.Type {
                view = targetClass.init()
            }

            view?.isRoot = false
            view?.currentBrick = Brick(name: brick.name, targetClass: brick.targetClass, nibName: brick.nibName)
            if let view = view {
                targetView.addSubview(view)
                view.lg_brickDidAwake()
            }
        }

        //TODO: sort brick's subviews to have as same order as bricks
        var viewsDictionary = [String: UIView]()
        for subview in targetView.subviews {
            if let name = subview.currentBrick?.name {
                viewsDictionary[name] = subview
            }
        }

        viewsDictionary["superview"] = targetView
        
        // Remove constraint with identifier (which means not created by system)
        targetView.removeConstraints(targetView.constraints.filter({ (constraint) -> Bool in
            if constraint.mode == .subviewsLayout {
                return true
            }
            return false
        }))

        // Layout each view with auto layout visual format language as brick.
        for format in layout.formats {
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: layout.options, metrics: layout.metrics.metrics(), views: viewsDictionary)
            for constraint in constraints {
                constraint.lg_setIdentifier(with: .subviewsLayout)
                targetView.addConstraint(constraint)
            }
        }
    }
}

