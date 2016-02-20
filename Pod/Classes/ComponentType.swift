//
//  ComponentType.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol Composable {
    func compositeSubcomponents(components: [ComponentTarget], layout: Layout)
}

extension Composable where Self: UIView {
    func compositeSubcomponents(components: [ComponentTarget], layout: Layout) {

        // remove components which do not exist anymore
        for subview in self.subviews {
            if let oldComponent = subview.configuration where !components.contains(oldComponent) {
                subview.cleanUpForReuse() // TODO: clean layout maybe
                subview.removeFromSuperview()
            }
        }

        // filter components already exist
        let filteredComponents = components.filter { (component) -> Bool in
            if let subcomponents = self.configuration?.components where !subcomponents.contains(component) {
                return false
            }
            return true
        }

        let views = filteredComponents.flatMap { (component) -> UIView? in
            var view: UIView? = nil;

            if let nibName = component.nibName,
                let componentView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView {
                    view = componentView
            } else if let componentView = ComponentFactory.componentViewFromClass(component.targetClass) {
                view = componentView
            }

            if let view = view {
                view.isRoot = false
                view.viewName = component.name
                self.addSubview(view)
            }

            return view
        }

        var viewsDictionary = [String: UIView]()
        for subview in self.subviews {
            if let name = subview.name {
                viewsDictionary[name] = subview
            }
        }

        // TODO: apply diff of layout instead of removing all constraints
        self.removeConstraints(self.constraints)

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
    }
}

protocol Configurable {
    func setupWithStyle(style: [Appearance])
    func handleCustomStyle(style: [String: AnyObject])
}


extension Configurable where Self: UIView {
    func handleCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown custom style \(style), should implement `handleCustomStyle:` in extension of UIView or its subclass.")
    }
    
    func setupWithStyle(style: [Appearance]) {
        if let oldStyle = self.configuration?.style {
            for old in oldStyle where !style.contains(old) {
                old.apply(to: self, useDefaultValue: true)
            }
        }

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

    // TODO: how to handle clean up for reuse
    final func cleanUpForReuse() {

        // do clean up
        for case let subview in self.subviews {
            subview.cleanUpForReuse()
        }
    }

    final func bind(newConfiguration: ComponentTarget, dataSource: ComponentDataSource?, updatingStrategy: ConfigurationUpdatingStrategy) {

        // resolve conf based on item?, indexPath? or others ?
        // willApply

        // TODO: should rebuild only layout or all?
        let shouldRebuild = self.shouldRebuild(with: self.configuration, newConfiguration: newConfiguration, updatingStrategy: updatingStrategy)

        self.configuration = newConfiguration

        // setup self
        if shouldRebuild {
            setupWithStyle(newConfiguration.style)
        }

        // update self
        dataSource?.updateComponent(self, with: newConfiguration)

        if shouldRebuild {
            // add & layout sub components
            if let components = newConfiguration.components where !components.isEmpty, let layout = newConfiguration.layout {
                compositeSubcomponents(components, layout: layout)
            }
        }
    }

    private func shouldRebuild(with currentConfiguration: ComponentTarget?, newConfiguration: ComponentTarget, updatingStrategy: ConfigurationUpdatingStrategy) -> Bool {

        // TODO: when screen size changed ? (rotation ?)

        var shouldRebuild = (currentConfiguration == nil)

        switch updatingStrategy {
        case .WhenComponentChanged:
            if let current = currentConfiguration where current.name != newConfiguration.name {
                shouldRebuild = true
            }
        case .Always:
            shouldRebuild = true
        }

        return shouldRebuild
    }
}

extension UILabel {
    func cleanUpForReuse() {
        self.text = nil
    }
}

extension UIImageView {
    func cleanUpForReuse() {
        self.image = nil
    }
}


