//
//  Layout.swift
//  LeeGo
//
//  Created by Victor WANG on 13/03/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation

public struct LayoutMetrics: Equatable {

    public let top: CGFloat
    public let left: CGFloat
    public let bottom: CGFloat
    public let right: CGFloat
    public let spaceH: CGFloat
    public let spaceV: CGFloat

    public let customMetrics: [String: CGFloat]

    public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat, _ spaceH: CGFloat, _ spaceV: CGFloat) {
        self.init(top:top, left: left, bottom: bottom, right: right, spaceH: spaceH, spaceV: spaceV)
    }

    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, spaceH: CGFloat = 0, spaceV: CGFloat = 0, customMetrics: [String: CGFloat] = [:]) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
        self.spaceH = spaceH
        self.spaceV = spaceV

        self.customMetrics = customMetrics
    }

    func metrics() -> [String: CGFloat] {
        return ["top": top, "left": left, "bottom": bottom, "right": right, "spaceH": spaceH, "spaceV": spaceV] + customMetrics
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

    public init(_ formats: [String] = [], options: NSLayoutFormatOptions = .DirectionLeadingToTrailing, metrics: LayoutMetrics = LayoutMetrics()) {
        self.formats = formats
        self.metrics = metrics
        self.options = options
    }

    public init(components: [String], axis: Axis, align: Alignment, distribution: Distribution, metrics: LayoutMetrics = LayoutMetrics()) {
        guard !components.isEmpty else {
            assertionFailure("Components should not be empty")
            self.init()
            return
        }

        let formats = formatHorizontal(components, axis: axis, align: align, distribution: distribution) + formatVertical(components, axis: axis, align: align, distribution: distribution)
        let options = layoutOptions(components, axis: axis, align: align, distribution: distribution)

        self.init(formats, options: options, metrics: metrics)
    }

}

public func ==(lhs: Layout, rhs: Layout) -> Bool {
    return lhs.formats == rhs.formats && lhs.metrics == rhs.metrics && lhs.options == rhs.options
}

