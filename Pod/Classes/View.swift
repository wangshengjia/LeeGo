//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

internal final class ComponentContext {
    var componentView: UIView? = nil
    var configuration: ConfigurationType?
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
}
