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

    var hashValue: Int {
        return String(self).hashValue
    }
}

//public func ==(lhs: ComponentProviderType, rhs: ComponentProviderType) -> Bool {
//    return String(lhs) == String(rhs)
//}

public class ComponentTarget: Hashable {
    let name: String
    let targetClass: AnyClass

    private(set) var style: [Appearance] = []
    private(set) var components: [ComponentTarget]? = nil {
        willSet {
            if let names = newValue?.map({ (component) -> String in
                return component.name
            }) where Set(names).count != newValue?.count {
                assertionFailure("Subcomponents share the same ancestor should have different names.")
            }
        }
    }
    private(set) var layout: Layout? = nil
    private(set) var width: CGFloat = 0.0

    public var hashValue: Int {
        return name.hashValue
    }

    public init(name: String, targetClass: AnyClass) {
        self.name = name
        self.targetClass = targetClass
    }

    public func style(style: [Appearance] = []) -> ComponentTarget {
        self.style = style
        return self
    }

    public func components(components: [ComponentTarget], layout: Layout) -> ComponentTarget {
        self.components = components
        self.layout = layout
        return self
    }

    public func components(c1: ComponentTarget, layout: (String) -> Layout) -> ComponentTarget {
        self.components = [c1]
        self.layout = layout(c1.name)
        return self
    }

    public func components(c1: ComponentTarget, _ c2: ComponentTarget, layout: (String, String) -> Layout) -> ComponentTarget {
        self.components = [c1, c2]
        self.layout = layout(c1.name, c2.name)
        return self
    }

    public func components(c1: ComponentTarget, _ c2: ComponentTarget, _ c3: ComponentTarget, layout: (String, String, String) -> Layout) -> ComponentTarget {
        self.components = [c1, c2, c3]
        self.layout = layout(c1.name, c2.name, c3.name)

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