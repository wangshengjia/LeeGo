//
//  Layout.swift
//  LeeGo
//
//  Created by Victor WANG on 13/03/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation

public struct LayoutMetrics: Equatable {

    private enum JSONKey: JSONKeyType {
        case top, left, bottom, right, spaceH, spaceV
    }

    public let top: CGFloat
    public let left: CGFloat
    public let bottom: CGFloat
    public let right: CGFloat
    public let spaceH: CGFloat
    public let spaceV: CGFloat

    public let customMetrics: [String: CGFloat]

    private var standardMetrics: [String: CGFloat] {
        return [JSONKey.top.asString: top,
                JSONKey.left.asString: left,
                JSONKey.bottom.asString: bottom,
                JSONKey.right.asString: right,
                JSONKey.spaceH.asString: spaceH,
                JSONKey.spaceV.asString: spaceV]
    }

    public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat, _ spaceH: CGFloat, _ spaceV: CGFloat) {
        self.init(top:top, left: left, bottom: bottom, right: right, spaceH: spaceH, spaceV: spaceV)
    }

    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, spaceH: CGFloat = 0, spaceV: CGFloat = 0, customMetrics: [String: CGFloat] = [:]) {

        self.top = customMetrics[JSONKey.top.asString] ?? top
        self.left = customMetrics[JSONKey.left.asString] ?? left
        self.bottom = customMetrics[JSONKey.bottom.asString] ?? bottom
        self.right = customMetrics[JSONKey.right.asString] ?? right
        self.spaceH = customMetrics[JSONKey.spaceH.asString] ?? spaceH
        self.spaceV = customMetrics[JSONKey.spaceV.asString] ?? spaceV


        self.customMetrics = customMetrics.filter({ (key, value) -> Bool in
            let top = key != JSONKey.top.asString
            let left = key != JSONKey.left.asString
            let bottom = key != JSONKey.bottom.asString
            let right = key != JSONKey.right.asString
            let spaceH = key != JSONKey.spaceH.asString
            let spaceV = key != JSONKey.spaceV.asString
            return top && left && bottom && right && spaceH && spaceV
        })
    }

    func encode() -> JSONDictionary {
        return customMetrics + standardMetrics.filter { (key, value) -> Bool in
            return value != 0.0
        }
    }

    func metrics() -> [String: CGFloat] {
        return customMetrics + standardMetrics
    }
}

public func ==(lhs: LayoutMetrics, rhs: LayoutMetrics) -> Bool {
    return lhs.top == rhs.top
        && lhs.left == rhs.left
        && lhs.bottom == rhs.bottom
        && lhs.right == rhs.right
        && lhs.spaceH == rhs.spaceH
        && lhs.spaceV == rhs.spaceV
        && lhs.customMetrics == rhs.customMetrics
}

public enum Axis {
    case Horizontal, Vertical
}

public enum Alignment {
    case Top, Left, Bottom, Right, Center, Fill
}

public enum Distribution {
    case Fill, FillEqually, Flow(Int)
}

public struct Layout: Equatable {

    let formats: [String]
    let options: NSLayoutFormatOptions
    let metrics: LayoutMetrics

    public init(bricks: [Brick], axis: Axis, align: Alignment, distribution: Distribution, metrics: LayoutMetrics = LayoutMetrics()) {
        let names: [String] = bricks.map { (brick) -> String in
            return brick.name
        }

        self.init(bricks: names, axis: axis, align: align, distribution: distribution, metrics: metrics)
    }

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

    public init(_ formats: [String] = [], options: NSLayoutFormatOptions = .DirectionLeadingToTrailing, metrics: LayoutMetrics = LayoutMetrics()) {
        self.formats = formats
        self.metrics = metrics
        self.options = options
    }
}


extension Layout: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case formats, options, metrics
    }

    public init(rawValue json: JSONDictionary) {
        let formats: [String] = (try? json.parse(JSONKey.formats)) ?? []

        var options: NSLayoutFormatOptions?
        if let optionsStr: [String] = (try? json.parse(JSONKey.options)) {
            options = NSLayoutFormatOptions(rawValue: optionsStr)
        }

        let metrics: [String: CGFloat] = (try? json.parse(JSONKey.metrics)) ?? [:]

        self.init(formats, options: options ?? .DirectionLeadingToTrailing, metrics: LayoutMetrics(customMetrics: metrics))
    }

    public func encode() -> JSONDictionary {
        return [JSONKey.formats.asString: formats, JSONKey.options.asString: options.encode(), JSONKey.metrics.asString: metrics.encode()]
    }
}

public func ==(lhs: Layout, rhs: Layout) -> Bool {
    return lhs.formats == rhs.formats && lhs.metrics == rhs.metrics && lhs.options == rhs.options
}

