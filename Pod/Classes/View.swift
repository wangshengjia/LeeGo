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

extension UIView: ComponentType {

    public func handleCustomStyle(style: [String: AnyObject]) {
        print("Should override and implement handleCustomStyle: ")
    }

    public func configure(with dataSource: ComponentDataSource? = nil, componentTarget: ComponentTarget) {

//        if context.isRoot {
//            setOwner(self)
//        }

        // will apply
//        let resolvedConfiguration = context.delegate?.willApply(with: componentTarget, toComponent: self, withItem: item, atIndexPath: nil) ?? componentTarget

        // apply resolved componentTarget
        if let cell = self as? UICollectionViewCell {
            cell.contentView.configure(dataSource, newConfiguration: componentTarget)
        } else if let cell = self as? UITableViewCell {
            cell.contentView.configure(dataSource, newConfiguration: componentTarget)
        } else {
            configure(dataSource, newConfiguration: componentTarget)
        }


        // did apply
//        context.delegate?.didApply(with: componentTarget, toComponent: self, withItem: item, atIndexPath: nil)

        // configure sub components recursively
        // for subview in self.subviews where subview.context.componentView == subview {
        for subview in self.subviews {
            if let componentTarget = subview.configuration {
                subview.configure(with: dataSource, componentTarget: componentTarget)
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
