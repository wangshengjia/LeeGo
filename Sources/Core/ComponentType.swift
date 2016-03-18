//
//  ComponentType.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol ComponentType: class, Configurable, Composable {
    func applyDiffTo<Component where Component: UIView, Component: ComponentType>(component: Component, newConfiguration: ComponentTarget, dataSource: ComponentDataSource?, updatingStrategy: ConfigurationUpdatingStrategy)
}

extension ComponentType {

    func applyDiffTo<Component where Component: UIView, Component: ComponentType>(component: Component, newConfiguration: ComponentTarget, dataSource: ComponentDataSource?, updatingStrategy: ConfigurationUpdatingStrategy) {

        // TODO: should rebuild only layout or all?
        if shouldRebuild(with: component.configuration, newConfiguration: newConfiguration, updatingStrategy: updatingStrategy) {
            apply(newConfiguration, to: component)
        }

        // update component's value
        dataSource?.updateComponent(component, with: newConfiguration)
    }

    private func apply<Component where Component: UIView, Component: ComponentType>(newConfiguration: ComponentTarget, to component: Component) {

        // setup self, only if component is not initialized from a nib file
        if component.configuration?.nibName == nil {
            setup(component, currentStyle: component.configuration?.style ?? [], newStyle: newConfiguration.style)
        }

        // handle component's width & height constraint
        applySize(newConfiguration, to: component)

        // add & layout sub components
        if let components = newConfiguration.components where !components.isEmpty, let layout = newConfiguration.layout {
            compositeSubcomponents(component, components: components, layout: layout)
        }
    }

    private func shouldRebuild(with currentConfiguration: ComponentTarget?, newConfiguration: ComponentTarget, updatingStrategy: ConfigurationUpdatingStrategy) -> Bool {

        // TODO: when screen size changed ? (rotation ?)

        var shouldRebuild = (currentConfiguration == nil)

        switch updatingStrategy {
        case .WhenComponentChanged:
            if let current = currentConfiguration
                where current.name != newConfiguration.name
                    || (current.style == [] && current.components == nil && current.layout == nil) {
                shouldRebuild = true
            }
        case .Always:
            shouldRebuild = true
        }

        return shouldRebuild
    }

    private func applySize<Component where Component: UIView, Component: ComponentType>(newConfiguration: ComponentTarget, to component: Component) {
        if let width = newConfiguration.width {
            component.applyConstraint(.Width, constant: width)
        } else {
            component.unapplyConstraint(.Width)
        }

        if let height = newConfiguration.height {
            component.applyConstraint(.Height, constant: height)
        } else {
            component.unapplyConstraint(.Height)
        }
    }
}

extension UIView {

    // TODO: improve later
    enum Constraint {
        case Width, Height

        var attribute: NSLayoutAttribute {
            switch self {
            case .Width:
                return .Width
            case .Height:
                return .Height
            }
        }
    }

    func constraint(type: Constraint) -> NSLayoutConstraint? {
        switch type {
        case .Width, .Height:
            for constraint in self.constraints {
                if constraint.firstAttribute == type.attribute
                    && constraint.firstItem === self && constraint.secondItem === nil {
                        return constraint
                }
            }
        }

        return nil
    }

    func applyConstraint(type: Constraint, constant: CGFloat) {
        if let constraint = self.constraint(type) {
            constraint.constant = constant
        } else {
            let constraint = NSLayoutConstraint(item: self, attribute: type.attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
            constraint.identifier = constraint.description
            self.addConstraint(constraint)
        }
    }

    func unapplyConstraint(type: Constraint) {
        if let constraint = self.constraint(type) where constraint.identifier != nil {
            self.removeConstraint(constraint)
        }
    }
}

// MARK: Component Context

private final class ComponentContext {
    var component: ComponentTarget?
    var isRoot = true
}

private struct AssociatedKeys {
    static var ComponentContextAssociatedKey = "ComponentContext_AssociatedKey"
}

extension ComponentType where Self: UIView {

    private var context: ComponentContext {
        get {
            if let context = objc_getAssociatedObject(self, &AssociatedKeys.ComponentContextAssociatedKey) as? ComponentContext {
                return context
            } else {
                let context = ComponentContext()
                objc_setAssociatedObject(self, &AssociatedKeys.ComponentContextAssociatedKey, context as ComponentContext?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return context
            }
        }
    }

    internal var configuration: ComponentTarget? {
        get {
            return context.component
        }
        set {
            context.component = newValue
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

}


