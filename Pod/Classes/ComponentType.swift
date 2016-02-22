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
        // setup self
        setup(component, currentStyle: component.configuration?.style ?? [], newStyle: newConfiguration.style)

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
            if let current = currentConfiguration where current.name != newConfiguration.name {
                shouldRebuild = true
            }
        case .Always:
            shouldRebuild = true
        }

        return shouldRebuild
    }
}

// MARK: Component Context

private final class ComponentContext {
    weak var owner: UIView?
    var viewName: String?
    var component: ComponentTarget?
    var isRoot = true

    // var delegate: ConfiguratorDelegate?
    // weak var dataSource: ComponentDataSource?
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


    //    internal func owner() -> UIView {
    //        context.owner = self
    //        return context.owner
    //    }

    //    internal var dataSource: ComponentDataSource? {
    //        get {
    //            return context.dataSource
    //        }
    //        set {
    //            context.dataSource = newValue
    //        }
    //    }

    internal var componentName: String? {
        return context.component?.name
    }

    internal var isRoot: Bool {
        get {
            return context.isRoot
        }
        set {
            context.isRoot = newValue
        }
    }

    internal var viewName: String? {
        get {
            return context.viewName
        }
        set {
            context.viewName = newValue
        }
    }
}


