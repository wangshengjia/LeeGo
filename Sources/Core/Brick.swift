//
//  Brick.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

// MARK: Brick Builder

public protocol BrickBuilderType: Hashable {
    // FIXME: do we really need Hashable?
    static var types: [Self: AnyClass] { get }
}

extension BrickBuilderType {

    public func buildFromNib(type: AnyObject? = nil, nibName: String) -> Brick {
        guard nibName != "" else {
            assertionFailure("Failed to build brick with an empty nibName")
            return target()
        }

        return Brick(name: self.brickName, targetClass: (type.self ?? UIView.self) as! AnyClass, nibName: nibName)
    }

    public func build(type: AnyObject? = nil) -> Brick {
        guard type != nil else {
            return target()
        }
        return Brick(name: self.brickName, targetClass: type.self as! AnyClass)
    }

    private func target() -> Brick {
        guard let targetClass = Self.types[self] else {
            return build(UIView)
        }
        return build(targetClass)
    }

    var hashValue: Int {
        return self.brickName.hashValue
    }

    public var brickName: String {
        return String(self)
    }
}

extension String: BrickBuilderType {
    public static var types: [String: AnyClass] = [:]
}

public func ==<Builder: BrickBuilderType>(lhs: Builder, rhs: Builder) -> Bool {
    return lhs.brickName == rhs.brickName
}

// MARK: Brick Target

public typealias ManuallyFittingHeightResolver = (fittingWidth: CGFloat, childrenHeights: [CGFloat], metrics: LayoutMetrics) -> CGFloat

public final class Brick {
    public let name: String

    let targetClass: AnyClass
    let nibName: String?

    private(set) var style: [Appearance] = []
    private(set) var bricks: [Brick]? = nil {
        willSet {
            if let names = newValue?.map({ (brick) -> String in
                return brick.name
            }) where Set(names).count != newValue?.count {
                assertionFailure("Subbricks share the same ancestor should have different names.")
            }
        }
    }
    private(set) var layout: Layout? = nil

    // brick width and height
    private(set) var width: CGFloat? = nil
    private(set) var height: CGFloat? = nil

    private(set) var LGOutletKey: String? = nil

    // TODO: need to make this API more clearly
    // used only for calculating cell's height manually
    private(set) var heightResolver: ManuallyFittingHeightResolver?

    internal init(name: String, targetClass: AnyClass = UIView.self, nibName: String? = nil) {
        self.name = name
        if targetClass is UIView.Type {
            self.targetClass = targetClass
        } else {
            assertionFailure("Can not handle type: \(targetClass), should be one of UIView's subclass")
            self.targetClass = UIView.self
        }
        self.nibName = nibName

    }

    public func style(style: [Appearance] = []) -> Brick {
        self.style = style
        return self
    }

    public func heightResolver(heightResolver: ManuallyFittingHeightResolver?) -> Brick {
        self.heightResolver = heightResolver
        return self
    }

    public func bricks(bricks: [Brick], layout: Layout) -> Brick {
        self.bricks = bricks
        self.layout = layout
        return self
    }

    public func bricks(c1: Brick, layout: (String) -> Layout) -> Brick {
        self.bricks = [c1]
        self.layout = layout(c1.name)
        return self
    }

    public func bricks(c1: Brick, _ c2: Brick, layout: (String, String) -> Layout) -> Brick {
        self.bricks = [c1, c2]
        self.layout = layout(c1.name, c2.name)
        return self
    }

    public func bricks(c1: Brick, _ c2: Brick, _ c3: Brick, layout: (String, String, String) -> Layout) -> Brick {
        self.bricks = [c1, c2, c3]
        self.layout = layout(c1.name, c2.name, c3.name)

        return self
    }

    public func bricks(c1: Brick, _ c2: Brick, _ c3: Brick, _ c4: Brick, layout: (String, String, String, String) -> Layout) -> Brick {
        self.bricks = [c1, c2, c3, c4]
        self.layout = layout(c1.name, c2.name, c3.name, c4.name)

        return self
    }

    public func bricks(c1: Brick, _ c2: Brick, _ c3: Brick, _ c4: Brick, _ c5: Brick, layout: (String, String, String, String, String) -> Layout) -> Brick {
        self.bricks = [c1, c2, c3, c4, c5]
        self.layout = layout(c1.name, c2.name, c3.name, c4.name, c5.name)

        return self
    }

    public func width(width: CGFloat) -> Brick {
        self.width = width
        return self
    }

    public func height(height: CGFloat) -> Brick {
        self.height = height
        return self
    }

    public func LGOutlet(key: String) -> Brick {
        self.LGOutletKey = key
        return self
    }
}

extension Brick: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case name, targetClass, nibName, width, height, style, layout, bricks, outlet
    }

    public convenience init(rawValue json: JSONDictionary) throws {
        do {
            let targetClass: AnyClass = ((try? NSClassFromString(json.parse(JSONKey.targetClass))) ?? nil) ?? UIView.self
            let nibName: String? = try? json.parse(JSONKey.nibName)
            try self.init(name: json.parse(JSONKey.name), targetClass: targetClass, nibName: nibName)
        } catch {
            throw JSONConvertibleError.UnexpectedBrickNameError(json)
        }

        if let styleJsons: JSONDictionary = try? json.parse(JSONKey.style) {
            self.style = Appearance.appearancesWithJSON(styleJsons)
        }

        if let brickJsons: [JSONDictionary] = try? json.parse(JSONKey.bricks) {
            self.bricks = brickJsons.flatMap({ (json) -> Brick? in
                return try? Brick(rawValue: json)
            })
        }

        if let layoutJson: JSONDictionary = try? json.parse(JSONKey.layout) {
            self.layout = Layout(rawValue: layoutJson)
        }

        self.width = try? json.parse(JSONKey.width)
        self.height = try? json.parse(JSONKey.height)
        self.LGOutletKey = try? json.parse(JSONKey.outlet)
    }

    public func encode() -> JSONDictionary {
        var json: JSONDictionary = [JSONKey.name.asString: self.name, JSONKey.targetClass.asString: String(self.targetClass)]

        if let nibName = self.nibName {
            json[JSONKey.nibName.asString] = nibName
        }

        if let width = self.width {
            json[JSONKey.width.asString] = width
        }

        if let height = self.height {
            json[JSONKey.height.asString] = height
        }

        if let layout = self.layout {
            json[JSONKey.layout.asString] = layout.encode()
        }

        if !self.style.isEmpty {
            json[JSONKey.style.asString] = Appearance.JSONWithAppearances(self.style)
        }

        if let bricks = self.bricks {
            let bricksJson = bricks.flatMap({ (brick) -> JSONDictionary? in
                return brick.encode()
            })

            if !bricksJson.isEmpty {
                json[JSONKey.bricks.asString] = bricksJson
            }
        }

        if let outlet = self.LGOutletKey {
            json[JSONKey.outlet.asString] = outlet
        }

        return json
    }
}

// MARK: Helpers

extension Brick {
    /*
    // TODO: complete these methods
    func replace(targetChild name: String, by newChild:Brick) -> Brick {

    }

    func replace(targetChild index: Int, by newChild:Brick) -> Brick {

    }*/

    public static func container(name: String = "container", within brick: Brick) -> Brick {
        return union(name, bricks: [brick], axis: Axis.Horizontal, align: Alignment.Fill, distribution: Distribution.Fill, metrics: LayoutMetrics())
    }

    public static func union(name: String, bricks: [Brick], axis: Axis, align: Alignment, distribution: Distribution, metrics: LayoutMetrics) -> Brick {
        let layout = Layout(bricks: bricks, axis: axis, align: align, distribution: distribution, metrics: metrics)

        return Brick(name: name).bricks(bricks, layout: layout)
    }
}

public func ==<Builder: BrickBuilderType>(lhs: Brick, rhs: Builder) -> Bool {
    return lhs.name == rhs.brickName
}

public func ==<Builder: BrickBuilderType>(lhs: Builder, rhs: Brick) -> Bool {
    return lhs.brickName == rhs.name
}

// MARK: Adapt protocols

extension Brick: Equatable {}

public func ==(lhs: Brick, rhs: Brick) -> Bool {
    return lhs.name == rhs.name
}

extension Brick: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

