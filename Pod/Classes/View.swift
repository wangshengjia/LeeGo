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
    case OnlyFristTime
    case WhenComponentChanged
    case Always
}

extension UIView: ComponentType {

    public func handleCustomStyle(style: [String: AnyObject]) {
        print("Should override and implement handleCustomStyle: ")
    }

    public func configure(componentTarget: ComponentTarget, dataSource: ComponentDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenComponentChanged) {

        // will apply
//        let resolvedConfiguration = context.delegate?.willApply(with: componentTarget, toComponent: self, withItem: item, atIndexPath: nil) ?? componentTarget

        // apply resolved componentTarget
        if let cell = self as? UICollectionViewCell {
            cell.contentView.bind(componentTarget, dataSource: dataSource)
        } else if let cell = self as? UITableViewCell {
            cell.contentView.bind(componentTarget, dataSource: dataSource)
        } else {
            bind(componentTarget, dataSource: dataSource)
        }


        // did apply
//        context.delegate?.didApply(with: componentTarget, toComponent: self, withItem: item, atIndexPath: nil)

        // configure sub components recursively
        // for subview in self.subviews where subview.context.componentView == subview {
        for subview in self.subviews {
            if let componentTarget = subview.configuration {
                subview.configure(componentTarget, dataSource: dataSource)
            }
        }
    }


    // not used
    func setValueSafely(value: AnyObject?, forKey key: String) {
        if self.respondsToSelector(Selector(key)) {
            self.setValue(value, forKey: key)
        }
    }
}


// MARK: Component Context

private final class ComponentContext {
    weak var owner: UIView?
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

    public func name() -> String? {
        return context.component?.name
    }
}
