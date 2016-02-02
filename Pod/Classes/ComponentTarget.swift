//
//  ComponentTarget.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol ComponentProviderType: Hashable {
    static var types: [Self: AnyClass] { get }
}

extension ComponentProviderType {
    public func type(type: AnyObject? = nil) -> ComponentTarget {
        if type == nil {
            return target()
        }
        return ComponentTarget(name: String(self), targetClass: type.self as! AnyClass)
    }

    func target() -> ComponentTarget {
        guard let targetClass = Self.types[self] else {
            return type(UIView)
        }
        return type(targetClass)
    }
}

public class ComponentTarget: Hashable {
    let name: String
    let targetClass: AnyClass

    // let componentTypes: Set<String> = []

    private(set) var configuration = Configuration()
    private(set) var width: CGFloat = 0.0

    public var hashValue: Int {
        return name.hashValue
    }

    public init(name: String, targetClass: AnyClass) {
        self.name = name
        self.targetClass = targetClass
    }

    public func config(config: Configuration) -> ComponentTarget {
        self.configuration = config
        return self
    }

    public func width(width: CGFloat) -> ComponentTarget {
        self.width = width
        return self
    }

}

public func ==(lhs: ComponentTarget, rhs: ComponentTarget) -> Bool {
    return lhs.name == rhs.name
}