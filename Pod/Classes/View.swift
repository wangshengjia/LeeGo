//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

internal final class ComponentContext {
    weak var componentView: UIView? = nil
    var component: ComponentTarget?
    var isRoot = true
    var delegate: ConfiguratorDelegate?

    init() {

    }
}

extension UIView: ComponentType {

    private struct AssociatedKeys {
        static var ComponentContextAssociatedKey = "ComponentContext_AssociatedKey"
    }

    internal var context: ComponentContext {
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

    public func handleCustomStyle(style: [String: AnyObject]) {
        print("defaut imp 2")
    }

    public func configure<Item : ItemType>(with item: Item, componentTarget: ComponentTarget) {

        if self.context.isRoot {
            self.context.componentView = self
        }

        // will apply
        let resolvedConfiguration = context.delegate?.willApply(with: componentTarget, toComponent: self, withItem: item, atIndexPath: nil) ?? componentTarget

        // apply resolved componentTarget
        if let cell = self as? UICollectionViewCell {
            cell.contentView.configure(item, component: resolvedConfiguration)
        } else if let cell = self as? UITableViewCell {
            cell.contentView.configure(item, component: resolvedConfiguration)
        } else {
            configure(item, component: resolvedConfiguration)
        }


        // did apply
        context.delegate?.didApply(with: componentTarget, toComponent: self, withItem: item, atIndexPath: nil)
    }

    public func name() -> String {
        return context.component?.name ?? "No Name"
    }
}
