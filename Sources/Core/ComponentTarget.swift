//
//  ComponentTarget.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

// MARK: Component Builder

public protocol ComponentBuilderType: Hashable, Equatable {
    // FIXME: do we really need Hashable?
    static var types: [Self: AnyClass] { get }
}

extension ComponentBuilderType {

    public func buildFromNib(type: AnyObject? = nil, name: String) -> ComponentTarget {
        // TODO: check type
        return ComponentTarget(name: self.name, targetClass: (type.self ?? UIView.self) as! AnyClass, nibName: name)
    }

    public func build(type: AnyObject? = nil) -> ComponentTarget {
        if type == nil {
            return target()
        }
        return ComponentTarget(name: self.name, targetClass: type.self as! AnyClass)
    }

    private func target() -> ComponentTarget {
        guard let targetClass = Self.types[self] else {
            return build(UIView)
        }
        return build(targetClass)
    }

    var hashValue: Int {
        return self.name.hashValue
    }

    public var name: String {
        return String(self)
    }
}

public func ==<Builder: ComponentBuilderType>(lhs: Builder, rhs: Builder) -> Bool {
    return lhs.name == rhs.name
}

// MARK: Component Target

public typealias ManuallyFittingHeightResolver = (fittingWidth: CGFloat, childrenHeights: [CGFloat], metrics: LayoutMetrics) -> CGFloat

public class ComponentTarget {
    public let name: String

    let targetClass: AnyClass
    let nibName: String?

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

    // component's width and height
    private(set) var width: CGFloat? = nil
    private(set) var height: CGFloat? = nil

    // TODO: need to make this API more clearly
    // used only for calculating cell's height manually
    private(set) var heightResolver: ManuallyFittingHeightResolver?

    public init(name: String, targetClass: AnyClass = UIView.self, nibName: String? = nil) {
        self.name = name
        if targetClass is UIView.Type {
            self.targetClass = targetClass
        } else {
            assertionFailure("Can not handle type: \(targetClass), should be one of UIView's subclass")
            self.targetClass = UIView.self
        }
        self.nibName = nibName

    }

    public func style(style: [Appearance] = []) -> ComponentTarget {
        self.style = style
        return self
    }

    public func heightResolver(heightResolver: ManuallyFittingHeightResolver?) -> ComponentTarget {
        self.heightResolver = heightResolver
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

    public func components(c1: ComponentTarget, _ c2: ComponentTarget, _ c3: ComponentTarget, _ c4: ComponentTarget, layout: (String, String, String, String) -> Layout) -> ComponentTarget {
        self.components = [c1, c2, c3, c4]
        self.layout = layout(c1.name, c2.name, c3.name, c4.name)

        return self
    }

    public func components(c1: ComponentTarget, _ c2: ComponentTarget, _ c3: ComponentTarget, _ c4: ComponentTarget, _ c5: ComponentTarget, layout: (String, String, String, String, String) -> Layout) -> ComponentTarget {
        self.components = [c1, c2, c3, c4, c5]
        self.layout = layout(c1.name, c2.name, c3.name, c4.name, c5.name)

        return self
    }

    public func width(width: CGFloat) -> ComponentTarget {
        self.width = width
        return self
    }

    public func height(height: CGFloat) -> ComponentTarget {
        self.height = height
        return self
    }
}

// MARK: Helpers

public func ==<Builder: ComponentBuilderType>(lhs: ComponentTarget, rhs: Builder) -> Bool {
    return lhs.name == rhs.name
}

public func ==<Builder: ComponentBuilderType>(lhs: Builder, rhs: ComponentTarget) -> Bool {
    return lhs.name == rhs.name
}

// MARK: Adapt protocols

extension ComponentTarget: Equatable {}

public func ==(lhs: ComponentTarget, rhs: ComponentTarget) -> Bool {
    return lhs.name == rhs.name
}

extension ComponentTarget: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

