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
    /// Brick's target class. You need to implment this property. 
    /// It usually looks like:
    ///
    ///     [.title: UILabel.self,
    ///      .avatar: UIImageView.self,
    ///      .follow: UIButton.self]
    ///
    /// If you have nothing to put here, just give an empty dictionary
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


// MARK: Brick

/// A closure used to resolve the cell's height.
/// It will be used only if needed when calculate the cell's height for UICollectionView.
///
/// The idea of this closure is to calculate cell's height
/// based on `cell width`, `subviews' height` and `metrics which used in autolayout`.
///
/// - Note: `childrenHeights` is an array of subviews' heights, values keep the same order as elements in `Brick.bricks`
/// - SeeAlso: `Brick`, `UIView.lg_fittingHeight()`
public typealias ManuallyFittingHeightResolver = (fittingWidth: CGFloat, childrenHeights: [CGFloat], metrics: LayoutMetrics) -> CGFloat

/// A `Brick` instance represent a piece of Lego's brick,
/// it could be a simple tiny brick such as:
/// ```
/// let brick = Brick(name: "title", targetClass: UILabel.self)
/// ```
/// or it can also be some way more complex brick 
/// which composed by a bunch of simple bricks. And this is
/// the whole idea of this framework: dealing with `bricks` as play with Lego.
///
/// A `brick` tells a view:
/// - What's the real view type
/// - How the view looks like
/// - What's inside
/// - How to layout them
///
/// `Brick` is design to be full value type which is
/// immutable, functional and thread-safe
public struct Brick {

    /// `name` stand for a name/type of a `brick`.
    /// The brick which have same name will be considered as the same brick
    /// - Warning: Usually you should not have different implementations of brick with same name
    /// - Note: For the moment, the `name` property is more or less act as an identifier.
    /// This should be improved later.
    public let name: String

    /// The dynamic type of the target view which will be created.
    /// So no doute it should a subclass of `UIView`.
    let targetClass: AnyClass

    /// Stand for the name of an IB file. If `nibName` is not
    /// nil or empty, the target view will be created by `loadNibNamed:`
    let nibName: String?

    /// An array of `Appearance`, which will be applied to view
    let style: [Appearance]?

    /// An array of `Brick` inside, represet for subviews
    let bricks: [Brick]?

    /// The `Layout` property indicate how to layout the `bricks` inside
    /// - SeeAlso: Brick.bricks
    let layout: Layout?

    /// Width and height
    let width: CGFloat?
    let height: CGFloat?

    /// Outlet key
    let LGOutletKey: String?

    /// A closure used to resolve the cell's height.
    /// It will be used only if needed when calculate the cell's height for UICollectionView.
    ///
    /// The idea of this closure is to calculate cell's height
    /// based on `cell width`, `subviews' height` and `metrics which used in autolayout`.
    ///
    /// - Example:
    ///
    /// ```
    /// heightResolver { (_, childrenHeights, metrics) -> CGFloat in
    ///   return childrenHeights[0] + childrenHeights[1] + metrics.top + metrics.bottom + metrics.spaceV
    /// }
    /// ```
    ///
    /// - Note: `childrenHeights` is an array of subviews' heights, values keep the same order as elements in `Brick.bricks`
    /// - SeeAlso: `Brick.ManuallyFittingHeightResolver`, `UIView.lg_fittingHeight()`
    let heightResolver: ManuallyFittingHeightResolver?

    internal init(name: String, targetClass: AnyClass = UIView.self, nibName: String? = nil) {
        self.init(name: name, targetClass: targetClass, nibName: nibName, width: nil, height: nil, style: nil, bricks: nil, layout: nil, LGOutletKey: nil, heightResolver: nil)
    }

    internal init(name: String, targetClass: AnyClass, nibName: String?, width: CGFloat?, height: CGFloat?, style: [Appearance]?, bricks: [Brick]?, layout: Layout?, LGOutletKey: String?, heightResolver: ManuallyFittingHeightResolver?) {

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

    ///  Return a new `Brick` instance with
    ///  given `Appearance` array.
    ///
    ///  - parameter style: `Appearance` array
    ///
    ///  - returns: new `Brick` instance with given array.
    public func style(style: [Appearance]) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    ///  Return a new `Brick` instance with
    ///  given sub `Brick` array and `Layout` instance
    ///  which tells the current brick how to layout
    ///  the sub-bricks
    ///
    ///  - parameter bricks: a `Brick` array represent the sub-bricks inside the current brick
    ///  - parameter layout: a 'Layout' instance should tell how to layout the sub-bricks which given by `bricks` array
    ///
    ///  - returns: new `Brick` instance with given `bricks` and `layout`
    public func bricks(bricks: [Brick], layout: Layout) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    ///  Return a new `Brick` instance with
    ///  given sub-bricks and closure
    ///
    ///  - parameter b1:     a sub-brick
    ///  - parameter layout: a closure which take 
    ///  `b1`'s name as parameter and return a `Layout` instance
    ///
    ///  - returns: new `Brick` instance with given `bricks` and `layout`
    public func bricks(b1: Brick, layout: (String) -> Layout) -> Brick {
        let bricks = [b1]
        let layout = layout(b1.name)

        return self.bricks(bricks, layout:layout)
    }

    ///  Return a new `Brick` instance with
    ///  given sub-bricks and closure
    ///
    ///  - parameter b1:     first sub-brick
    ///  - parameter b2:     second sub-brick
    ///  - parameter layout: a closure which take
    ///  sub-bricks' name as parameters with the same order and return a `Layout` instance
    ///
    ///  - returns: new `Brick` instance with given `bricks` and `layout`
    public func bricks(b1: Brick, _ b2: Brick, layout: (String, String) -> Layout) -> Brick {
        let bricks = [b1, b2]
        let layout = layout(b1.name, b2.name)

        return self.bricks(bricks, layout:layout)
    }

    ///  Return a new `Brick` instance with
    ///  given sub-bricks and closure
    ///
    ///  - parameter b1:     first sub-brick
    ///  - parameter b2:     second sub-brick
    ///  - parameter b3:     third sub-brick
    ///  - parameter layout: a closure which take
    ///  sub-bricks' name as parameters with the same order and return a `Layout` instance
    ///
    ///  - returns: new `Brick` instance with given `bricks` and `layout`
    public func bricks(b1: Brick, _ b2: Brick, _ b3: Brick, layout: (String, String, String) -> Layout) -> Brick {
        let bricks = [b1, b2, b3]
        let layout = layout(b1.name, b2.name, b3.name)

        return self.bricks(bricks, layout:layout)
    }

    ///  Return a new `Brick` instance with
    ///  given sub-bricks and closure
    ///
    ///  - parameter b1:     first sub-brick
    ///  - parameter b2:     second sub-brick
    ///  - parameter b3:     third sub-brick
    ///  - parameter b4:     fouth sub-brick
    ///  - parameter layout: a closure which take
    ///  sub-bricks' name as parameters with the same order and return a `Layout` instance
    ///
    ///  - returns: new `Brick` instance with given `bricks` and `layout`
    public func bricks(b1: Brick, _ b2: Brick, _ b3: Brick, _ b4: Brick, layout: (String, String, String, String) -> Layout) -> Brick {
        let bricks = [b1, b2, b3, b4]
        let layout = layout(b1.name, b2.name, b3.name, b4.name)

        return self.bricks(bricks, layout:layout)
    }

    ///  Return a new `Brick` instance with
    ///  given sub-bricks and closure.
    ///
    ///  - parameter b1:     first sub-brick
    ///  - parameter b2:     second sub-brick
    ///  - parameter b3:     third sub-brick
    ///  - parameter b4:     fouth sub-brick
    ///  - parameter b5:     fifth sub-brick
    ///  - parameter layout: a closure which take
    ///  sub-bricks' name as parameters with the same order and return a `Layout` instance
    ///
    ///  - returns: new `Brick` instance with given `bricks` and `layout`
    public func bricks(b1: Brick, _ b2: Brick, _ b3: Brick, _ b4: Brick, _ b5: Brick, layout: (String, String, String, String, String) -> Layout) -> Brick {
        let bricks = [b1, b2, b3, b4, b5]
        let layout = layout(b1.name, b2.name, b3.name, b4.name, b5.name)

        return self.bricks(bricks, layout:layout)
    }

    ///  Return a new `Brick` instance with the given width.
    ///
    ///  - Note: `width` will be considered as a width autolayout 
    ///  constraint and be added on the view configured by this brick
    ///
    ///  - parameter width: the width value in CGFloat
    ///
    ///  - returns: new `Brick` instance with given `width`
    public func width(width: CGFloat) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    ///  Return a new `Brick` instance with the given height.
    ///
    ///  - Note: `height` will be considered as a height autolayout
    ///  constraint and be added on the view configured by this brick
    ///
    ///  - parameter height: the height value in CGFloat
    ///
    ///  - returns: new `Brick` instance with given `height`
    public func height(height: CGFloat) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    /// Return a new `Brick` instance with the given closure. The closure used to resolve the cell's height.
    /// It will be used only if needed when calculate the cell's height for UICollectionView.
    ///
    /// The idea of this closure is to calculate cell's height
    /// based on `cell width`, `subviews' height` and `metrics which used in autolayout`.
    ///
    /// - Example:
    ///
    /// ```
    /// heightResolver { (_, childrenHeights, metrics) -> CGFloat in
    ///   return childrenHeights[0] + childrenHeights[1] + metrics.top + metrics.bottom + metrics.spaceV
    /// }
    /// ```
    ///
    ///  - Note: `childrenHeights` is an array of subviews' heights, values keep the same order as elements in `Brick.bricks`
    ///  - SeeAlso: `Brick.ManuallyFittingHeightResolver`, `UIView.lg_fittingHeight()`
    ///
    ///  - parameter heightResolver: a closure used only if needed when calculate the cell's height for UICollectionView.
    ///
    ///  - returns: new `Brick` instance with given closure
    public func heightResolver(heightResolver: ManuallyFittingHeightResolver?) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }

    ///  Return a new `Brick` instance with the given outlet key. Inspired by IBOutlet.
    ///
    ///  - SeeAlso: UIView.lg_viewForOutletKey(key: String)
    ///  - parameter LGOutletKey: A key used to retrieve the view later.
    ///
    ///  - returns: new `Brick` instance with the given key.
    public func LGOutlet(LGOutletKey: String) -> Brick {
        return Brick(name: name, targetClass: targetClass, nibName: nibName, width: width, height: height, style: style, bricks: bricks, layout: layout, LGOutletKey: LGOutletKey, heightResolver: heightResolver)
    }
}

extension Brick: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case name, targetClass, nibName, width, height, style, layout, bricks, outlet
    }

    ///  Initilaze a `Brick` instance from JSONDictionary.
    ///
    ///  - parameter json: a [String: AnyObject] instance. [Here is a sample]()
    ///
    ///  - throws: it's possible to throw errors, such as Errors.JSONParseError & Errors.JSONConvertibleError
    ///
    ///  - returns: new `Brick` instance converted from given json
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

    ///  Encode `self` into a JSONDictionary object.
    ///
    ///  - returns: a `JSONDictionary` instance encoded from `self`
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

    ///  Helper method to create a `Brick` as a role of the "container" to the given brick.
    ///
    ///  - parameter name:  name of the new brick, default is "container"
    ///  - parameter brick: the child brick
    ///
    ///  - returns: new `Brick` instance within the given brick
    public static func container(name: String = "container", within brick: Brick) -> Brick {
        return union(name, bricks: [brick], axis: Axis.Horizontal, align: Alignment.Fill, distribution: Distribution.Fill, metrics: LayoutMetrics())
    }

    ///  Helper method to create a `Brick` by union two or more given bricks.
    ///
    ///  - parameter name:         the name of the new brick
    ///  - parameter bricks:       children bricks
    ///  - parameter axis:         children bricks layout -> Layout.Axis
    ///  - parameter align:        children bricks layout -> Layout.Alignement
    ///  - parameter distribution: children bricks layout -> Layout.Distribution
    ///  - parameter metrics:      children bricks layout -> LayoutMetrics
    ///
    ///  - returns: new `Brick` instance within the given bricks
    public static func union(name: String, bricks: [Brick], axis: Axis, align: Alignment, distribution: Distribution, metrics: LayoutMetrics) -> Brick {
        let layout = Layout(bricks: bricks, axis: axis, align: align, distribution: distribution, metrics: metrics)

        return Brick(name: name).bricks(bricks, layout: layout)
    }
}

///  Return true if they have the same name
///
///  - parameter lhs: a `Brick` instance
///  - parameter rhs: a brick `Builder` instance
///
///  - returns: true if they have the same name
public func ==<Builder: BrickBuilderType>(lhs: Brick, rhs: Builder) -> Bool {
    return lhs.name == rhs.brickName
}

///  Return true if they have the same name
///
///  - parameter lhs: a brick `Builder` instance
///  - parameter rhs: a `Brick` instance
///
///  - returns: true if they have the same name
public func ==<Builder: BrickBuilderType>(lhs: Builder, rhs: Brick) -> Bool {
    return lhs.brickName == rhs.name
}

// MARK: Adapt protocols

extension Brick: Equatable {}

///  Return true if they have the same name
///
///  - parameter lhs: a `Brick` instance
///  - parameter rhs: another `Brick` instance
///
///  - returns: true if they have the same name
public func ==(lhs: Brick, rhs: Brick) -> Bool {
    return lhs.name == rhs.name
}

extension Brick: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

