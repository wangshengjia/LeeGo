//
//  AutoLayout.swift
//  LeeGo
//
//  Created by Victor WANG on 04/02/16.
//
//

import Foundation

// MARK: Public

extension NSLayoutRelation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .equal:
            return ""
        case .greaterThanOrEqual:
            return ">="
        case .lessThanOrEqual:
            return "<="
        }
    }
}

///  Represent a metric key could be used in LayoutMetrics.
///  Ex, `left` & `right`:
///  ```
///  let format = "H:|-left-[view]-(>=right)-|"
///  ```
///
///  - top:         "top"
///  - bottom:      "bottom"
///  - left:        "left"
///  - right:       "right"
///  - spaceH:      "spaceH", horizontal space
///  - spaceV:      "spaceV", vertical space
///  - none:        ""
///  - custom:      custom metric key

public enum Metrics: CustomStringConvertible {
    case top(NSLayoutRelation), bottom(NSLayoutRelation), left(NSLayoutRelation), right(NSLayoutRelation), spaceH(NSLayoutRelation), spaceV(NSLayoutRelation), none, custom(String)


    public var description: String {
        switch self {
        case let .top(relation):
            return relation == .equal ? "-top-" : "-(\(relation)top)-"
        case let .left(relation):
            return relation == .equal ? "-left-" : "-(\(relation)left)-"
        case let .bottom(relation):
            return relation == .equal ? "-bottom-" : "-(\(relation)bottom)-"
        case let .right(relation):
            return relation == .equal ? "-right-" : "-(\(relation)right)-"
        case let .spaceH(relation):
            return relation == .equal ? "-spaceH-" : "-(\(relation)spaceH)-"
        case let .spaceV(relation):
            return relation == .equal ? "-spaceV-" : "-(\(relation)spaceV)-"
        default:
            break
        }
        return ""
    }
}

// MARK: Public functions

///  Helper method to make create horizontal VFL format easier.
///  Ex:
///  ```
///  Layout([
///    H(orderedViews: [illustration, title]),
///    H(fromSuperview: false, orderedViews: [illustration, subtitle]),
///    V(orderedViews: [title, subtitle], bottom: .bottom(.GreaterThanOrEqual)),
///    V(orderedViews: [illustration], bottom: .bottom(.GreaterThanOrEqual)),
///  ], metrics: LayoutMetrics(20, 20, 20 ,20 ,10 ,10))
///  ```
///
///  - parameter fromSuperview: Determine if there is a constraint leading from superview, such as: "H:|-". Default is true.
///  - parameter left:          Determine the relation of `left` metric. Default is equal.
///  - parameter orderedViews:  The target views name, they will be added one by one horizontally with interspace.
///  - parameter interspace:    Determine the relation of `spaceH`. Default is equal.
///  - parameter right:         Determine the relation of `right` metric. Default is equal.
///  - parameter toSuperview:   Determine if there is a constraint trailing to superview, such as: "H:...-|". Default is true.
///
///  - returns: the VFL format string
public func H(fromSuperview: Bool = true, left: Metrics? = .left(.equal), orderedViews: [String] = [], interspace: Metrics? = .spaceH(.equal), right: Metrics? = .right(.equal), toSuperview: Bool = true) -> String {
    guard !orderedViews.isEmpty else {
        assertionFailure("Should at least have 1 view name")
        return ""
    }

    return "H:" + distribute(fromSuperview: fromSuperview, metric1: left, views: orderedViews, interspace: interspace, metric2: right, toSuperview: toSuperview)
}

///  Helper method to make create vertical VFL format easier.
///  Ex:
///  ```
///  Layout([
///    H(orderedViews: [illustration, title]),
///    H(fromSuperview: false, orderedViews: [illustration, subtitle]),
///    V(orderedViews: [title, subtitle], bottom: .bottom(.GreaterThanOrEqual)),
///    V(orderedViews: [illustration], bottom: .bottom(.GreaterThanOrEqual)),
///  ], metrics: LayoutMetrics(20, 20, 20 ,20 ,10 ,10))
///  ```
///
///  - parameter fromSuperview: Determine if there is a constraint leading from superview, such as: "V:|-". Default is true.
///  - parameter top:          Determine the relation of `top` metric. Default is equal.
///  - parameter orderedViews:  The target views name, they will be added one by one vertically with interspace.
///  - parameter interspace:    Determine the relation of `spaceV`. Default is equal.
///  - parameter bottom:         Determine the relation of `bottom` metric. Default is equal.
///  - parameter toSuperview:   Determine if there is a constraint trailing to superview, such as: "V:...-|". Default is true.
///
///  - returns: the VFL format string
public func V(fromSuperview: Bool = true, top: Metrics? = .top(.equal), orderedViews: [String] = [], interspace: Metrics? = .spaceV(.equal), bottom: Metrics? = .bottom(.equal), toSuperview: Bool = true) -> String {
    guard !orderedViews.isEmpty else {
        assertionFailure("Should at least have 1 view name")
        return ""
    }

    return "V:" + distribute(fromSuperview: fromSuperview, metric1: top, views: orderedViews, interspace: interspace, metric2: bottom, toSuperview: toSuperview)
}

// MARK: Internal

internal func formatHorizontal(_ brickNames: [String], axis: Axis, align: Alignment, distribution: Distribution) -> [String] {
    guard !brickNames.isEmpty else {
        assertionFailure("`brickNames` should not be empty")
        return []
    }

    if axis == .horizontal {
        switch distribution {
        case .fill:
            return [H(orderedViews: brickNames)]
        case .fillEqually:
            return [H(orderedViews: brickNames)] + equallyLayoutFormats(brickNames, axis: .horizontal)
        case let .flow(index):
            let left = Array(brickNames.prefix(min(max(index, 0), brickNames.count)))
            let right = Array(brickNames.suffix(min(max(brickNames.count - index, 0), brickNames.count)))

            if left.isEmpty {
                return [H(left: .left(.greaterThanOrEqual), orderedViews:right)]
            } else if right.isEmpty {
                return [H(orderedViews:left, right: .right(.greaterThanOrEqual))]
            } else {
                let str = H(fromSuperview: false, orderedViews:right)
                let index = str.characters.index(str.startIndex, offsetBy: 2)
                return [H(orderedViews:left, toSuperview: false) + Metrics.spaceH(.greaterThanOrEqual).description + str.substring(from: index)]
            }
        }
    } else {
        return brickNames.flatMap { (brick) -> String? in

            switch align {
            case .left:
                return H(orderedViews:[brick], right:.right(.greaterThanOrEqual))
            case .right:
                return H(left:.left(.greaterThanOrEqual), orderedViews:[brick])
            case .fill:
                return H(orderedViews:[brick])
            case .center:
                return H(left:.left(.greaterThanOrEqual), orderedViews:[brick], right:.right(.greaterThanOrEqual))
            default:
                assertionFailure("Unexpected alignment value \(align) for axis \(axis) and distribution \(distribution)")
                return nil
            }
        }
    }
}

internal func formatVertical(_ brickNames: [String], axis: Axis, align: Alignment, distribution: Distribution) -> [String] {
    guard !brickNames.isEmpty else {
        assertionFailure("Bricks should not be empty")
        return []
    }

    if axis == .horizontal {
        return brickNames.flatMap { (brick) -> String? in

            switch align {
            case .top:
                return V(orderedViews:[brick], bottom:.bottom(.greaterThanOrEqual))
            case .bottom:
                return V(top:.top(.greaterThanOrEqual), orderedViews:[brick])
            case .fill:
                return V(orderedViews:[brick])
            case .center:
                return V(top:.top(.greaterThanOrEqual), orderedViews:[brick], bottom:.bottom(.greaterThanOrEqual))
            default:
                assertionFailure("Unexpected alignment value \(align) for axis \(axis) and distribution \(distribution)")
                return nil
            }
        }
    } else {
        switch distribution {
        case .fill:
            return [V(orderedViews:brickNames)]
        case .fillEqually:
            return [V(orderedViews: brickNames)] + equallyLayoutFormats(brickNames, axis: .vertical)
        case let .flow(index):
            let top = Array(brickNames.prefix(min(max(index, 0), brickNames.count)))
            let bottom = Array(brickNames.suffix(min(max(brickNames.count - index, 0), brickNames.count)))

            if top.isEmpty {
                return [V(top: .top(.greaterThanOrEqual), orderedViews:bottom)]
            } else if bottom.isEmpty {
                return [V(orderedViews: top, bottom: .bottom(.greaterThanOrEqual))]
            } else {
                let str = V(fromSuperview: false, orderedViews:bottom)
                let index = str.characters.index(str.startIndex, offsetBy: 2)
                return [V(orderedViews: top, toSuperview: false) + Metrics.spaceV(.greaterThanOrEqual).description + str.substring(from: index)]
            }
        }
    }
}

internal func layoutOptions(_ brickNames: [String], axis: Axis, align: Alignment, distribution: Distribution) -> NSLayoutFormatOptions {
    if axis == .horizontal && align == .center {
        return [.alignAllCenterY, .directionLeadingToTrailing]
    }

    if axis == .vertical && align == .center {
        return [.alignAllCenterX, .directionLeadingToTrailing]
    }

    // Default
    return NSLayoutFormatOptions()
}

// MARK: Private

private func equallyLayoutFormats(_ brickNames: [String], axis: Axis) -> [String] {
    guard brickNames.count >= 2 else {
        assertionFailure("Should almost have two views to do a equally layout")
        return []
    }

    return brickNames.enumerated().flatMap { (index: Int, element: String) -> String? in
        if index < brickNames.count - 1 {
            return "\(axis == .horizontal ? "H" : "V"):[\(element)(\(brickNames[index + 1]))]"
        }
        return nil
    }
}

private func distribute(fromSuperview: Bool, metric1: Metrics?, views: [String], interspace: Metrics?, metric2: Metrics?, toSuperview: Bool) -> String{

    var format = ""

    if fromSuperview {
        format = format + "|"
        if let left = metric1 {
            format = format + left.description
        }
    }


    for viewName in views {
        format = format + "[\(viewName)]"

        if let spaceH = interspace, viewName != views.last {
            format = format + spaceH.description
        }
    }

    if toSuperview {
        if let right = metric2 {
            format = format + right.description
        }
        format = format + "|"
    }
    
    return format
}
