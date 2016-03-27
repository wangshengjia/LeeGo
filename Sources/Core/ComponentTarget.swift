//
//  ComponentTarget.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

//public protocol JSONPrintable {
//    var descriptionInJSONFormat: String { get }
//}

func printJSON(json: JSONDictionary) {
    do {
        let data = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
        let jsonStr = String(data: data, encoding: NSUTF8StringEncoding)!
        print(jsonStr)
    } catch {
        print(error)
    }
}

// MARK: Component Builder

public protocol ComponentBuilderType: Hashable, Equatable {
    // FIXME: do we really need Hashable?
    static var types: [Self: AnyClass] { get }
}

extension ComponentBuilderType {

    public func buildFromNib(type: AnyObject? = nil, nibName: String) -> ComponentTarget {
        guard nibName != "" else {
            assertionFailure("Failed to build component with an empty nibName")
            return target()
        }

        return ComponentTarget(name: self.name, targetClass: (type.self ?? UIView.self) as! AnyClass, nibName: nibName)
    }

    public func build(type: AnyObject? = nil) -> ComponentTarget {
        guard type != nil else {
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

public final class ComponentTarget {
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

    private(set) var LGOutletKey: String? = nil

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

    public func LGOutlet(key: String) -> ComponentTarget {
        self.LGOutletKey = key
        return self
    }
}

extension ComponentTarget: Encodable, Decodable {

    private enum JSONKey: JSONKeyType {
        case name, type, nibName, width, height, style, layout, components, outlet
    }

    public convenience init?(json: JSONDictionary) {
        do {
            let targetClass: AnyClass = ((try? NSClassFromString(json.parse(JSONKey.name))) ?? nil) ?? UIView.self
            let nibName: String? = try? json.parse(JSONKey.nibName)
            try self.init(name: json.parse(JSONKey.name), targetClass: targetClass, nibName: nibName)
        } catch {
            return nil
        }

        if let styleJsons: JSONDictionary = try? json.parse(JSONKey.style) {
            self.style = Appearance.appearancesWithJSON(styleJsons)
        }

        if let componentJsons: [JSONDictionary] = try? json.parse(JSONKey.components) {
            self.components = componentJsons.flatMap({ (json) -> ComponentTarget? in
                return ComponentTarget(json: json)
            })
        }

        if let layoutJson: JSONDictionary = try? json.parse(JSONKey.layout) {
            self.layout = Layout(json: layoutJson)
        }

        self.width = try? json.parse(JSONKey.width)
        self.height = try? json.parse(JSONKey.height)
        self.LGOutletKey = try? json.parse(JSONKey.outlet)
    }

    // TODO: decode/encode with custom error handling
    public func encode() -> JSONDictionary? {
        var json: JSONDictionary = [JSONKey.name.asString: self.name, JSONKey.type.asString: String(self.targetClass)]

        if let nibName = self.nibName {
            json[JSONKey.nibName.asString] = nibName
        }

        if let width = self.width {
            json[JSONKey.width.asString] = width
        }

        if let height = self.height {
            json[JSONKey.height.asString] = height
        }

        if let layout = self.layout, let layoutJson = layout.encode() {
            json[JSONKey.layout.asString] = layoutJson
        }

        if !self.style.isEmpty {
            json[JSONKey.style.asString] = Appearance.JSONWithAppearances(self.style)
        }

        if let components = self.components {
            let componentsJson = components.flatMap({ (component) -> JSONDictionary? in
                return component.encode()
            })

            if !componentsJson.isEmpty {
                json[JSONKey.components.asString] = componentsJson
            }
        }

        if let outlet = self.LGOutletKey {
            json[JSONKey.outlet.asString] = outlet
        }

        return json
    }
}

// MARK: Helpers

extension ComponentTarget {
    /*
    // TODO: complete these methods
    func replace(targetChild name: String, by newChild:ComponentTarget) -> ComponentTarget {

    }

    func replace(targetChild index: Int, by newChild:ComponentTarget) -> ComponentTarget {

    }*/

    public static func container(name: String = "container", within component: ComponentTarget) -> ComponentTarget {
        return union(name, components: [component], axis: Axis.Horizontal, align: Alignment.Fill, distribution: Distribution.Fill, metrics: LayoutMetrics())
    }

    public static func union(name: String = "default_component", components: [ComponentTarget], axis: Axis, align: Alignment, distribution: Distribution, metrics: LayoutMetrics) -> ComponentTarget {
        let layout = Layout(components: components, axis: axis, align: align, distribution: distribution, metrics: metrics)

        return ComponentTarget(name: name).components(components, layout: layout)
    }
}

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

