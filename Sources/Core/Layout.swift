//
//  Layout.swift
//  LeeGo
//
//  Created by Victor WANG on 13/03/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation

///  Represent the metrics pair could be used when create the auto layout constraint.
public struct LayoutMetrics: Equatable {

    private enum JSONKey: JSONKeyType {
        case top, left, bottom, right, spaceH, spaceV
    }

    /// Represent top metrics pair, such as: ["top": top]
    public let top: CGFloat
    /// Represent left metrics pair, such as: ["left": left]
    public let left: CGFloat
    /// Represent bottom metrics pair, such as: ["bottom": bottom]
    public let bottom: CGFloat
    /// Represent right metrics pair, such as: ["right": right]
    public let right: CGFloat
    /// Represent spaceH metrics pair, such as: ["spaceH": spaceH]
    public let spaceH: CGFloat
    /// Represent spaceV metrics pair, such as: ["spaceV": top]
    public let spaceV: CGFloat

    /// Represent metrics pair with custom key/value
    public let customMetrics: [String: CGFloat]

    private var standardMetrics: [String: CGFloat] {
        return [JSONKey.top.asString: top,
                JSONKey.left.asString: left,
                JSONKey.bottom.asString: bottom,
                JSONKey.right.asString: right,
                JSONKey.spaceH.asString: spaceH,
                JSONKey.spaceV.asString: spaceV]
    }

    ///  Initializer with 6 built-in metrics, without default values.
    ///
    ///  - parameter top:    top metrics
    ///  - parameter left:   left metrics
    ///  - parameter bottom: bottom metrics
    ///  - parameter right:  right metrics
    ///  - parameter spaceH: spaceH metrics
    ///  - parameter spaceV: spaceV metrics
    ///
    ///  - returns: `LayoutMetrics` instance
    public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat, _ spaceH: CGFloat, _ spaceV: CGFloat) {
        self.init(top:top, left: left, bottom: bottom, right: right, spaceH: spaceH, spaceV: spaceV)
    }

    ///  Initializer with 6 built-in metrics and custom metrics.
    ///
    ///  - parameter top:    top metrics, default is zero
    ///  - parameter left:   left metrics, default is zero
    ///  - parameter bottom: bottom metrics, default is zero
    ///  - parameter right:  right metrics, default is zero
    ///  - parameter spaceH: spaceH metrics, default is zero
    ///  - parameter spaceV: spaceV metrics, default is zero
    ///  - parameter customMetrics: custom metrics pair, , default is empty
    ///
    ///  - returns: `LayoutMetrics` instance
    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, spaceH: CGFloat = 0, spaceV: CGFloat = 0, customMetrics: [String: CGFloat] = [:]) {

        self.top = customMetrics[JSONKey.top.asString] ?? top
        self.left = customMetrics[JSONKey.left.asString] ?? left
        self.bottom = customMetrics[JSONKey.bottom.asString] ?? bottom
        self.right = customMetrics[JSONKey.right.asString] ?? right
        self.spaceH = customMetrics[JSONKey.spaceH.asString] ?? spaceH
        self.spaceV = customMetrics[JSONKey.spaceV.asString] ?? spaceV


        self.customMetrics = customMetrics.filter(includeElement: { (key, value) -> Bool in
            let top = key != JSONKey.top.asString
            let left = key != JSONKey.left.asString
            let bottom = key != JSONKey.bottom.asString
            let right = key != JSONKey.right.asString
            let spaceH = key != JSONKey.spaceH.asString
            let spaceV = key != JSONKey.spaceV.asString
            return top && left && bottom && right && spaceH && spaceV
        })
    }

    internal func encode() -> JSONDictionary {
        return customMetrics + standardMetrics.filter { (key, value) -> Bool in
            return value != 0.0
        }
    }

    internal func metrics() -> [String: CGFloat] {
        return customMetrics + standardMetrics
    }
}

///  Return true if 6 built-in metrics and custom metrics are all equals.
///
///  - parameter lhs: a LayoutMetrics
///  - parameter rhs: another LayoutMetrics
///
///  - returns: true if 6 built-in metrics and custom metrics are all equals.
public func ==(lhs: LayoutMetrics, rhs: LayoutMetrics) -> Bool {
    return lhs.top == rhs.top
        && lhs.left == rhs.left
        && lhs.bottom == rhs.bottom
        && lhs.right == rhs.right
        && lhs.spaceH == rhs.spaceH
        && lhs.spaceV == rhs.spaceV
        && lhs.customMetrics == rhs.customMetrics
}

///  Represent the layout direction of views. Inspired from UIStackView.
///
///  - Horizontal: Horizontal
///  - Vertical:   Vertical
public enum Axis {
    case horizontal, vertical
}

///  Represent the layout alignment of views. Inspired from UIStackView.
///
///  - Top:    views will be aligned on top, only with Axis.Horizontal
///  - Left:   views will be aligned on left, only with Axis.Vertical
///  - Bottom: views will be aligned on bottom, only with Axis.Horizontal
///  - Right:  views will be aligned on right, only with Axis.Vertical
///  - Center: views will be aligned at the middle
///  - Fill:   views will be enlarged to fill the superview
public enum Alignment {
    case top, left, bottom, right, center, fill
}

///  Represent the layout distribution of views. Inspired from UIStackView.
///
///  - Fill:        Views will filled the available place. Equal to: "H:|[view1]|"
///  - FillEqually: Views will filled the available place with same width on horizontal and height on vertical. Equal to: "H:|[view1][view2(view1)]|"
///  - Flow:        Views will be placed one by one as a chain. You can specify an index to break the chain.
///
///  Ex: Given Flow(2) for view1, view2, view3, view4, view5
///  ```
///  "H:|-left-[view1]-spaceH-[view2]-(>=spaceH)-[view3]-spaceH-[view4]-spaceH-[view5]-right-|"
///        |             |                 |                |              |             |
///  idx <= 0           = 1               = 2 (break)      = 3            = 4          >= 5
///  ```
public enum Distribution {
    case fill, fillEqually, flow(Int)
}

///  Represent the layout of sub-bricks inside the brick.
///  Which completely based on standard autolayout for iOS.
public struct Layout: Equatable {

    /// Represent standard VFL format strings
    internal let formats: [String]
    /// Represent standard NSLayoutFormatOptions used to create a constraint
    internal let options: NSLayoutFormatOptions
    /// Represent standard metrics used to create a constraint
    internal let metrics: LayoutMetrics

    ///  Initializer to build a `Layout` object for given bricks, using a way inspired from UIStackView
    ///
    ///  - parameter bricks:       bricks to layout
    ///  - parameter axis:         Layout.Axis
    ///  - parameter align:        Layout.Alignment
    ///  - parameter distribution: Layout.Distribution
    ///  - parameter metrics:      LayoutMetrics
    ///
    ///  - returns: new `Layout` instance
    public init(bricks: [Brick], axis: Axis, align: Alignment, distribution: Distribution, metrics: LayoutMetrics = LayoutMetrics()) {
        let names: [String] = bricks.map { (brick) -> String in
            return brick.name
        }

        self.init(bricks: names, axis: axis, align: align, distribution: distribution, metrics: metrics)
    }

    ///  Initializer to build a `Layout` object for given bricks, using a way inspired from UIStackView
    ///
    ///  - parameter bricks:       the names of bricks to layout
    ///  - parameter axis:         Layout.Axis
    ///  - parameter align:        Layout.Alignment
    ///  - parameter distribution: Layout.Distribution
    ///  - parameter metrics:      LayoutMetrics
    ///
    ///  - returns: new `Layout` instance
    public init(bricks: [String], axis: Axis, align: Alignment, distribution: Distribution, metrics: LayoutMetrics = LayoutMetrics()) {
        guard !bricks.isEmpty else {
            assertionFailure("Bricks should not be empty")
            self.init()
            return
        }

        let formats = formatHorizontal(bricks, axis: axis, align: align, distribution: distribution) + formatVertical(bricks, axis: axis, align: align, distribution: distribution)
        let options = layoutOptions(bricks, axis: axis, align: align, distribution: distribution)

        self.init(formats, options: options, metrics: metrics)
    }

    ///  Initializer to build a `Layout` object with raw data.
    ///
    ///  - parameter formats: standard VFL format strings
    ///  - parameter options: standard NSLayoutFormatOptions
    ///  - parameter metrics: LayoutMetrics
    ///
    ///  - returns: new `Layout` instance
    public init(_ formats: [String] = [], options: NSLayoutFormatOptions = NSLayoutFormatOptions(), metrics: LayoutMetrics = LayoutMetrics()) {
        self.formats = formats
        self.metrics = metrics
        self.options = options
    }
}


extension Layout: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case formats, options, metrics
    }

    ///  Initializer to build a `Layout` object with given JSON
    ///
    ///  - parameter json: [String: AnyObject]
    ///
    ///  - returns: new `Layout` instance
    public init(rawValue json: JSONDictionary) {
        let formats: [String] = (try? json.parse(JSONKey.formats)) ?? []

        var options: NSLayoutFormatOptions?
        if let optionsStr: [String] = (try? json.parse(JSONKey.options)) {
            options = NSLayoutFormatOptions(rawValue: optionsStr)
        }

        let metrics: [String: CGFloat] = (try? json.parse(JSONKey.metrics)) ?? [:]

        self.init(formats, options: options ?? NSLayoutFormatOptions(), metrics: LayoutMetrics(customMetrics: metrics))
    }

    ///  Convert `self` to JSON
    ///
    ///  - returns: [String: AnyObject]
    public func encode() -> JSONDictionary {
        return [JSONKey.formats.asString: formats, JSONKey.options.asString: options.encode(), JSONKey.metrics.asString: metrics.encode()]
    }
}

///  Equatable
///
///  - parameter lhs: a `Layout` instance
///  - parameter rhs: another `Layout` instance
///
///  - returns: true if equals
public func ==(lhs: Layout, rhs: Layout) -> Bool {
    return lhs.formats == rhs.formats && lhs.metrics == rhs.metrics && lhs.options == rhs.options
}

