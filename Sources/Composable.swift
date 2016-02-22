//
//  Composable.swift
//  Pods
//
//  Created by Victor WANG on 21/02/16.
//
//

import Foundation

protocol Composable {
    func compositeSubcomponents<Component where Component: UIView, Component: ComponentType>(component: Component, components: [ComponentTarget], layout: Layout)
}

extension Composable {
    func compositeSubcomponents<Component where Component: UIView, Component: ComponentType>(component: Component, components: [ComponentTarget], layout: Layout) {

        // remove components which do not exist anymore
        for subview in component.subviews {
            if let oldComponent = subview.configuration where !components.contains(oldComponent) {
                // subview.cleanUpForReuse() // TODO: clean layout maybe
                subview.removeFromSuperview()
            }
        }

        // filter components already exist
        let filteredComponents = components.filter { (subComponent) -> Bool in
            if let subcomponents = component.configuration?.components where !subcomponents.contains(subComponent) {
                return false
            }
            return true
        }

        filteredComponents.forEach { componentTarget in
            var view: UIView? = nil;

            if let nibName = componentTarget.nibName,
                let componentView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView {
                    view = componentView
            } else if let componentView = ComponentFactory.componentViewFromClass(componentTarget.targetClass) {
                view = componentView
            }

            view?.isRoot = false
            view?.viewName = componentTarget.name
            if let view = view {
                component.addSubview(view)
            }
        }

        

        var viewsDictionary = [String: UIView]()
        for subview in component.subviews {
            if let name = subview.name {
                viewsDictionary[name] = subview
            }
        }

        // TODO: apply diff of layout instead of removing all constraints
        component.removeConstraints(component.constraints)

        // Layout each component view with auto layout visual format language from configuration.
        for format in layout.formats {
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: layout.metrics, views: viewsDictionary)
            for constraint in constraints {
                //constraint.priority = 990
                //constraint.shouldBeArchived = true
                constraint.identifier = constraint.description
                component.addConstraint(constraint)
            }
        }
    }
}