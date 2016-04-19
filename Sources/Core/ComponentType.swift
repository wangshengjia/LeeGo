//
//  BrickType.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol BrickType: class, Configurable, Composable {
    func componentDidAwake()

    func apply<Component where Component: UIView, Component: BrickType>(component: Component, newConfiguration: Brick, dataSource: ComponentDataSource?, updatingStrategy: ConfigurationUpdatingStrategy)
}

extension BrickType {

    func apply<Component where Component: UIView, Component: BrickType>(component: Component, newConfiguration: Brick, dataSource: ComponentDataSource?, updatingStrategy: ConfigurationUpdatingStrategy) {

        if shouldRebuild(with: component.configuration, newConfiguration: newConfiguration, updatingStrategy: updatingStrategy) {
            applyDiff(with: newConfiguration, to: component)
        }

        // update component's value
        dataSource?.updateComponent(component, with: newConfiguration)
    }

    private func applyDiff<Component where Component: UIView, Component: BrickType>(with newConfiguration: Brick, to component: Component) {

        // setup self, only if component is not initialized from a nib file
        if component.configuration?.nibName == nil {
            setup(component, currentStyle: component.configuration?.style ?? [], newStyle: newConfiguration.style)
        }

        // handle component's width & height constraint
        applyDimension(newConfiguration, to: component)

        // add & layout sub components
        if let components = newConfiguration.components where !components.isEmpty, let layout = newConfiguration.layout {
            compositeSubcomponents(component, components: components, layout: layout)
        }
    }

    private func shouldRebuild(with currentConfiguration: Brick?, newConfiguration: Brick, updatingStrategy: ConfigurationUpdatingStrategy) -> Bool {

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

    private func applyDimension<Component where Component: UIView, Component: BrickType>(newConfiguration: Brick, to component: Component) {
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
                if constraint.firstAttribute == type.attribute && constraint.identifier?.hasPrefix("dimension:") ?? false
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
            constraint.identifier = "dimension: \(constraint.description)"
            self.addConstraint(constraint)
        }
    }

    func unapplyConstraint(type: Constraint) {
        if let constraint = self.constraint(type) {
            self.removeConstraint(constraint)
        }
    }
}

// MARK: Component Context

private final class ComponentContext {
    var component: Brick?
    var isRoot = true
    var attributesArray: [Attributes] = []
}

private struct AssociatedKeys {
    static var ComponentContextAssociatedKey = "ComponentContext_AssociatedKey"
}

extension BrickType where Self: UIView {

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

    internal var configuration: Brick? {
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

    internal var attributesArray: [Attributes] {
        get {
            return context.attributesArray
        }
        set {
            context.attributesArray = newValue
        }
    }

}


