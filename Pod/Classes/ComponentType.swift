//
//  ComponentType.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol Configurable {
    func setupWithStyle(style: [Appearance])
    func handleCustomStyle(style: [String: AnyObject])
}

protocol Composable {
    func compositeSubcomponents(components: [ComponentTarget], layout: Layout) -> [UIView: ComponentTarget]
}

extension Composable where Self: UIView {
    func compositeSubcomponents(components: [ComponentTarget], layout: Layout) -> [UIView: ComponentTarget] {

        var subcomponents: [UIView: ComponentTarget] = [:]
        // create subview
        var viewsDictionary = [String: UIView]()
        for component in components {
            if let nibName = component.nibName,
                let componentView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView {
                    viewsDictionary[component.name] = componentView
                    self.addSubview(componentView)

                    // Setup each component view with style which listed in configuration
                    componentView.context.componentView = componentView
                    componentView.context.isRoot = false

                    subcomponents[componentView] = component
            }
            // It seems to me that there is no way to init an instance from class in Swift, so we made it in ObjC
            else if let componentView = ComponentFactory.componentViewFromClass(component.targetClass) {
                viewsDictionary[component.name] = componentView
                self.addSubview(componentView)

                // Setup each component view with style which listed in configuration
                componentView.context.componentView = componentView
                componentView.context.isRoot = false

                subcomponents[componentView] = component
            }
        }

        // apply diff, update the part only if changed
        /*
        for case let subview as Configurable in self.subviews {
        subview.setupWithConfiguration(configuration)
        }
        */

        // Layout each component view with auto layout visual format language from configuration.
        for format in layout.formats {
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: layout.metrics, views: viewsDictionary)
            for constraint in constraints {
                //constraint.priority = 990
                //constraint.shouldBeArchived = true
                constraint.identifier = constraint.description
                self.addConstraint(constraint)
            }
        }
        return subcomponents
    }
}

extension Configurable where Self: UIView {
    func handleCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown custom style \(style), should implement `handleCustomStyle:` in extension of UIView or its subclass.")
    }
    
    func setupWithStyle(style: [Appearance]) {
        for appearance in style {
            appearance.apply(to: self)
        }
    }
}

protocol ComponentType: Configurable, Composable {

}

extension ComponentType where Self: UIView {
//
//    func configure(item: ItemType, indexPath: NSIndexPath? = nil) {
//        
//    }

    final func cleanUpForReuse() {

        // do clean up
        for case let subview in self.subviews {
            subview.cleanUpForReuse()
        }
    }

    final func configure(dataSource: ComponentDataSource?, component: ComponentTarget) {

        // resolve conf based on item?, indexPath? or others ?
        // willApply

        var shouldRebuild = false

        if let ComponentTarget = self.context.component {
            // TODO: apply diff from config & configuration
            shouldRebuild = (ComponentTarget.style != component.style)
        } else {
            shouldRebuild = true
        }

        self.context.component = component

        // setup self
        if shouldRebuild {
            setupWithStyle(component.style)
        }

        // update self
        // updateWithItem(item)
        dataSource?.updateComponent(self, with: component)

        if shouldRebuild {
            // add & layout sub components
            if let components = component.components, let layout = component.layout {
                let subcomponents = compositeSubcomponents(components, layout: layout)
                for (component, componentTarget) in subcomponents {
                    component.configure(with: dataSource, componentTarget: componentTarget)
                }

                return
            }
        }

        // configure sub components recursively
        for subview in self.subviews where subview.context.componentView == subview {
            if let componentTarget = subview.context.component {
                subview.configure(with: dataSource, componentTarget: componentTarget)
            }
        }
    }
}


