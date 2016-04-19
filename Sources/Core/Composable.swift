//
//  Composable.swift
//  Pods
//
//  Created by Victor WANG on 21/02/16.
//
//

import Foundation

protocol Composable {
    func compositeSubcomponents<B where B: UIView, B: BrickType>(component: B, components: [Brick], layout: Layout)
}

extension Composable {
    func compositeSubcomponents<B where B: UIView, B: BrickType>(component: B, components: [Brick], layout: Layout) {

        // remove components which do not exist anymore
        for subview in component.subviews {
            if let oldBrick = subview.configuration where !components.contains(oldBrick) {
                subview.removeFromSuperview()
            }
        }

        // filter components already exist
        let filteredBricks = components.filter { (subBrick) -> Bool in
            if let subcomponents = component.configuration?.components where subcomponents.contains(subBrick) {
                for subview in component.subviews {
                    if let subcomponent2 = subview.configuration where subcomponent2 == subBrick {
                        return false
                    }
                }
            }
            return true
        }

        filteredBricks.forEach { brick in
            var view: UIView? = nil;

            if let nibName = brick.nibName,
                let componentView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView {
                    view = componentView
            } else if let targetClass = brick.targetClass as? UIView.Type {
                view = targetClass.init()
            }

            view?.isRoot = false
            view?.configuration = Brick(name: brick.name, targetClass: brick.targetClass, nibName: brick.nibName)
            if let view = view {
                component.addSubview(view)
                view.componentDidAwake()
            }
        }

        //TODO: sort component's subviews to have as same order as components

        var viewsDictionary = [String: UIView]()
        for subview in component.subviews {
            if let name = subview.configuration?.name {
                viewsDictionary[name] = subview
            }
        }

        // TODO: apply diff of layout instead of removing all constraints (not sure if possible)
        // Remove constraint with identifier (which means not created by system)
        component.removeConstraints(component.constraints.filter({ (constraint) -> Bool in
            if let identifier: String = constraint.identifier where identifier.hasPrefix("children:") {
                return true
            }
            return false
        }))

        // Layout each component view with auto layout visual format language from configuration.
        for format in layout.formats {
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: layout.options, metrics: layout.metrics.metrics(), views: viewsDictionary)
            for constraint in constraints {
                // TODO: need a better constraint identifier solution
                constraint.identifier = "children: \(constraint.description)"
                component.addConstraint(constraint)
            }
        }
    }
}

