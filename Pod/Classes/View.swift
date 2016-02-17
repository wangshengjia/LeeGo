//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol ComponentDataSource: class {
    func updateComponent(componentView: UIView, with componentTarget: ComponentTarget)
}

public enum ConfigurationUpdatingStrategy {
    case WhenComponentChanged
    case Always
}

extension UIView: ComponentType {

    public func handleCustomStyle(style: [String: AnyObject]) {
        print("Should override and implement handleCustomStyle: ")
    }

    public func configure(componentTarget: ComponentTarget, dataSource: ComponentDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenComponentChanged) {
        if let cell = self as? UICollectionViewCell {
            cell.contentView._configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else if let cell = self as? UITableViewCell {
            cell.contentView._configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else {
            _configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        }
    }

    private func _configure(componentTarget: ComponentTarget, dataSource: ComponentDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenComponentChanged) {

        // apply componentTarget
        bind(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)

        // TODO: improve this ugly implementation
        // configure sub components recursively
        for subview in self.subviews {
            if let viewName = subview.viewName {
                if let components = componentTarget.components {
                    for component in components where component.name == viewName {
                        subview.configure(component, dataSource: dataSource, updatingStrategy: updatingStrategy)
                    }
                }
            }
        }
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

extension UIView {
    private struct AssociatedKeys {
        static var ComponentContextAssociatedKey = "ComponentContext_AssociatedKey"
    }

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

    internal var isRoot: Bool {
        get {
            return context.isRoot
        }
        set {
            context.isRoot = newValue
        }
    }

    public  var name: String? {
        get {
            if let name = context.component?.name {
                return name
            } else {
                return context.viewName
            }
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
