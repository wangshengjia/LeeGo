//
//  Brick.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

/// A `BrickBuilderType` protocol provider useful functions to build
/// a `Brick` instance.
///
/// - Warning: You should almost always use an `enum` as the concrete 
/// implementation of this protocol.
public protocol BrickBuilderType: Hashable {
    /// Brick's target class. Usually looks like:
    ///
    ///     [.title: UILabel.self,
    ///      .avatar: UIImageView.self,
    ///      .follow: UIButton.self]
    ///
    /// Default value is `UIView.self`
    static var brickClass: [Self: AnyClass] { get }
}

extension BrickBuilderType {
    /// Create a `Brick` instance with the specific class type. Ex:
    ///
    ///     let brick = build(UILabel)
    ///
    public func build(type: AnyObject? = nil) -> Brick {
        guard type != nil else {
            return target()
        }
        return Brick(name: self.brickName, targetClass: type.self as! AnyClass)
    }

    /// Create a `Brick` instance with the specific class type and the 
    /// name of nib file. Ex:
    ///
    ///     let brick = buildFromNib(CustomLabel, nibName: "CustomLabel")
    ///
    public func buildFromNib(type: AnyObject? = nil, nibName: String) -> Brick {
        guard nibName != "" else {
            assertionFailure("Failed to build brick with an empty nibName")
            return target()
        }

        return Brick(name: self.brickName, targetClass: (type.self ?? UIView.self) as! AnyClass, nibName: nibName)
    }

    /// By default, it return `String(self)`.
    /// Usually `self` would be an enum instance, such as:
    /// `title`, `subtitle`, `avatar`, etc...
    /// It can overrided with your own implementation
    public var brickName: String {
        return String(self)
    }

    private func target() -> Brick {
        guard let targetClass = Self.brickClass[self] else {
            return build(UIView)
        }
        return build(targetClass)
    }

    var hashValue: Int {
        return self.brickName.hashValue
    }
}

/// Return true if two `Builder` have same brick name
public func ==<Builder: BrickBuilderType>(lhs: Builder, rhs: Builder) -> Bool {
    return lhs.brickName == rhs.brickName
}

/// String conform `BrickBuilderType`, so you can create
/// a `Brick` instance by a `String` instance. Ex:
///
///     let titleBrick = "title".build(UILabel)
///
extension String: BrickBuilderType {
    public static var brickClass: [String: AnyClass] = [:]

    /// The `brickName` would return string itself
    public var brickName: String {
        return self
    }
}


// MARK: Brick Target

/// A closure used to resolve the real cell's height.
/// The idea of this closure is to calculate cell's height
/// based on `cell width`, `subviews' height` and `metrics which used in autolayout`
///
/// - Note: `childrenHeights` is an array of subviews' heights, values keep the same order as `Brick.bricks`
/// - SeeAlso: `Brick`, `UIView.fittingHeight()`
public typealias ManuallyFittingHeightResolver = (fittingWidth: CGFloat, childrenHeights: [CGFloat], metrics: LayoutMetrics) -> CGFloat

/// A `Brick` instance represent
public struct Brick {
    public let name: String

    let targetClass: AnyClass
    let nibName: String?

    let style: [Appearance]?
    let bricks: [Brick]?
    let layout: Layout?

    // brick width and height
    let width: CGFloat?
    let height: CGFloat?

    let LGOutletKey: String?

    let heightResolver: ManuallyFittingHeightResolver?

    internal init(name: String, targetClass: AnyClass = UIView.self, nibName: String? = nil) {
        self.init(name: name, targetClass: targetClass, nibName: nibName, width: nil, height: nil, style: nil, bricks: nil, layout: nil, LGOutletKey: nil, heightResolver: nil)
    }

    init(name: String, targetClass: AnyClass, nibName: String?, width: CGFloat?, height: CGFloat?, style: [Appearance]?, bricks: [Brick]?, layout: Layout?, LGOutletKey: String?, heightResolver: ManuallyFittingHeightResolver?) {

        self.name = name
        if targetClass is UIView.Type {
            self.targetClass = targetClass
        } else {
            assertionFailure("Can not handle type: \(targetClass), should be one of UIView's subclass")
            self.targetClass = UIView.self
        }
        self.nibName = nibName
        self.width = width
        self.height = height
        self.style = style
        self.bricks = bricks
        self.layout = layout
        self.LGOutletKey = LGOutletKey
        self.heightResolver = heightResolver

        if let names = self.bricks?.map({ (brick) -> String in
            return brick.name
        }) where Set(names).count != self.bricks?.count {
            assertionFailure("Subbricks share the same ancestor should have different names.")
        }
    }

    public func style(style: [Appearance] = []) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    public func heightResolver(heightResolver: ManuallyFittingHeightResolver?) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    public func bricks(bricks: [Brick], layout: Layout) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    public func bricks(c1: Brick, layout: (String) -> Layout) -> Brick {
        let bricks = [c1]
        let layout = layout(c1.name)

        return self.bricks(bricks, layout:layout)
    }

    public func bricks(c1: Brick, _ c2: Brick, layout: (String, String) -> Layout) -> Brick {
        let bricks = [c1, c2]
        let layout = layout(c1.name, c2.name)

        return self.bricks(bricks, layout:layout)
    }

    public func bricks(c1: Brick, _ c2: Brick, _ c3: Brick, layout: (String, String, String) -> Layout) -> Brick {
        let bricks = [c1, c2, c3]
        let layout = layout(c1.name, c2.name, c3.name)

        return self.bricks(bricks, layout:layout)
    }

    public func bricks(c1: Brick, _ c2: Brick, _ c3: Brick, _ c4: Brick, layout: (String, String, String, String) -> Layout) -> Brick {
        let bricks = [c1, c2, c3, c4]
        let layout = layout(c1.name, c2.name, c3.name, c4.name)

        return self.bricks(bricks, layout:layout)
    }

    public func bricks(c1: Brick, _ c2: Brick, _ c3: Brick, _ c4: Brick, _ c5: Brick, layout: (String, String, String, String, String) -> Layout) -> Brick {
        let bricks = [c1, c2, c3, c4, c5]
        let layout = layout(c1.name, c2.name, c3.name, c4.name, c5.name)

        return self.bricks(bricks, layout:layout)
    }

    public func width(width: CGFloat) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    public func height(height: CGFloat) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    public func LGOutlet(LGOutletKey: String) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }
}

extension Brick: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case name, targetClass, nibName, width, height, style, layout, bricks, outlet
    }

    public init(rawValue json: JSONDictionary) throws {
        do {
            self.name = try json.parse(JSONKey.name)
        } catch {
            throw JSONConvertibleError.UnexpectedBrickNameError(json)
        }

        self.targetClass = ((try? NSClassFromString(json.parse(JSONKey.targetClass))) ?? nil) ?? UIView.self
        self.nibName = try? json.parse(JSONKey.nibName)

        if let styleJsons: JSONDictionary = try? json.parse(JSONKey.style) {
            self.style = Appearance.appearancesWithJSON(styleJsons)
        } else {
            self.style = nil
        }

        if let brickJsons: [JSONDictionary] = try? json.parse(JSONKey.bricks) {
            self.bricks = brickJsons.flatMap({ (json) -> Brick? in
                return try? Brick(rawValue: json)
            })
        } else {
            self.bricks = nil
        }

        if let layoutJson: JSONDictionary = try? json.parse(JSONKey.layout) {
            self.layout = Layout(rawValue: layoutJson)
        } else {
            self.layout = nil
        }

        self.width = try? json.parse(JSONKey.width)
        self.height = try? json.parse(JSONKey.height)
        self.LGOutletKey = try? json.parse(JSONKey.outlet)
        
        self.heightResolver = nil
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

        if let style = self.style where !style.isEmpty {
            json[JSONKey.style.asString] = Appearance.JSONWithAppearances(style)
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

