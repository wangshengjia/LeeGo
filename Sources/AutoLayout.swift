//
//  AutoLayout.swift
//  Pods
//
//  Created by Victor WANG on 04/02/16.
//
//

import Foundation

// MARK: Public

extension NSLayoutRelation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Equal:
            return ""
        case .GreaterThanOrEqual:
            return ">="
        case .LessThanOrEqual:
            return "<="
        }
    }
}

public enum Metrics: CustomStringConvertible {
    case top(NSLayoutRelation), bottom(NSLayoutRelation), left(NSLayoutRelation), right(NSLayoutRelation), spaceH(NSLayoutRelation), spaceV(NSLayoutRelation), none, custom(String)


    public var description: String {
        switch self {
        case let .top(relation):
            return relation == .Equal ? "-top-" : "-(\(relation)top)-"
        case let .left(relation):
            return relation == .Equal ? "-left-" : "-(\(relation)left)-"
        case let .bottom(relation):
            return relation == .Equal ? "-bottom-" : "-(\(relation)bottom)-"
        case let .right(relation):
            return relation == .Equal ? "-right-" : "-(\(relation)right)-"
        case let .spaceH(relation):
            return relation == .Equal ? "-spaceH-" : "-(\(relation)spaceH)-"
        case let .spaceV(relation):
            return relation == .Equal ? "-spaceV-" : "-(\(relation)spaceV)-"
        default:
            break
        }
        return ""
    }
}

// MARK: Public functions

public func H(fromSuperview fromSuperview: Bool = true, left: Metrics? = .left(.Equal), orderedViews: [String] = [], interspace: Metrics? = .spaceH(.Equal), right: Metrics? = .right(.Equal), toSuperview: Bool = true) -> String {
    guard !orderedViews.isEmpty else {
        assertionFailure("Should at least have 1 view name")
        return ""
    }

    return "H:" + distribute(fromSuperview: fromSuperview, metric1: left, views: orderedViews, interspace: interspace, metric2: right, toSuperview: toSuperview)
}

public func V(fromSuperview fromSuperview: Bool = true, top: Metrics? = .top(.Equal), orderedViews: [String] = [], interspace: Metrics? = .spaceV(.Equal), bottom: Metrics? = .bottom(.Equal), toSuperview: Bool = true) -> String {
    guard !orderedViews.isEmpty else {
        assertionFailure("Should at least have 1 view name")
        return ""
    }

    return "V:" + distribute(fromSuperview: fromSuperview, metric1: top, views: orderedViews, interspace: interspace, metric2: bottom, toSuperview: toSuperview)
}

// MARK: Internal

internal func formatHorizontal(brickNames: [String], axis: Axis, align: Alignment, distribution: Distribution) -> [String] {
    guard !brickNames.isEmpty else {
        assertionFailure("Bricks should not be empty")
        return []
    }

    if axis == .Horizontal {
        switch distribution {
        case .Fill:
            return [H(orderedViews: brickNames)]
        case .FillEqually:
            return [H(orderedViews: brickNames)] + equallyLayoutFormats(brickNames, axis: .Horizontal)
        case let .Flow(index):
            let left = Array(brickNames.prefix(min(max(index, 0), brickNames.count)))
            let right = Array(brickNames.suffix(min(max(brickNames.count - index, 0), brickNames.count)))

            if left.isEmpty {
                return [H(left: .left(.GreaterThanOrEqual), orderedViews:right)]
            } else if right.isEmpty {
                return [H(orderedViews:left, right: .right(.GreaterThanOrEqual))]
            } else {
                let str = H(fromSuperview: false, orderedViews:right)
                let index = str.startIndex.advancedBy(2)
                return [H(orderedViews:left, toSuperview: false) + Metrics.spaceH(.GreaterThanOrEqual).description + str.substringFromIndex(index)]
            }
        }
    } else {
        return brickNames.flatMap { (brick) -> String? in

            switch align {
            case .Left:
                return H(orderedViews:[brick], right:.right(.GreaterThanOrEqual))
            case .Right:
                return H(left:.left(.GreaterThanOrEqual), orderedViews:[brick])
            case .Fill:
                return H(orderedViews:[brick])
            case .Center:
                return H(left:.left(.GreaterThanOrEqual), orderedViews:[brick], right:.right(.GreaterThanOrEqual))
            default:
                assertionFailure("Unexpected alignment value \(align) for axis \(axis) and distribution \(distribution)")
                return nil
            }
        }
    }
}

internal func formatVertical(brickNames: [String], axis: Axis, align: Alignment, distribution: Distribution) -> [String] {
    guard !brickNames.isEmpty else {
        assertionFailure("Bricks should not be empty")
        return []
    }

    if axis == .Horizontal {
        return brickNames.flatMap { (brick) -> String? in

            switch align {
            case .Top:
                return V(orderedViews:[brick], bottom:.bottom(.GreaterThanOrEqual))
            case .Bottom:
                return V(top:.top(.GreaterThanOrEqual), orderedViews:[brick])
            case .Fill:
                return V(orderedViews:[brick])
            case .Center:
                return V(top:.top(.GreaterThanOrEqual), orderedViews:[brick], bottom:.bottom(.GreaterThanOrEqual))
            default:
                assertionFailure("Unexpected alignment value \(align) for axis \(axis) and distribution \(distribution)")
                return nil
            }
        }
    } else {
        switch distribution {
        case .Fill:
            return [V(orderedViews:brickNames)]
        case .FillEqually:
            return [V(orderedViews: brickNames)] + equallyLayoutFormats(brickNames, axis: .Vertical)
        case let .Flow(index):
            let top = Array(brickNames.prefix(min(max(index, 0), brickNames.count)))
            let bottom = Array(brickNames.suffix(min(max(brickNames.count - index, 0), brickNames.count)))

            if top.isEmpty {
                return [V(top: .top(.GreaterThanOrEqual), orderedViews:bottom)]
            } else if bottom.isEmpty {
                return [V(orderedViews: top, bottom: .bottom(.GreaterThanOrEqual))]
            } else {
                let str = V(fromSuperview: false, orderedViews:bottom)
                let index = str.startIndex.advancedBy(2)
                return [V(orderedViews: top, toSuperview: false) + Metrics.spaceV(.GreaterThanOrEqual).description + str.substringFromIndex(index)]
            }
        }
    }
}

internal func layoutOptions(brickNames: [String], axis: Axis, align: Alignment, distribution: Distribution) -> NSLayoutFormatOptions {
    if axis == .Horizontal && align == .Center {
        return [.AlignAllCenterY, .DirectionLeadingToTrailing]
    }

    if axis == .Vertical && align == .Center {
        return [.AlignAllCenterX, .DirectionLeadingToTrailing]
    }

    // Default
    return .DirectionLeadingToTrailing
}

// MARK: Private

private func equallyLayoutFormats(brickNames: [String], axis: Axis) -> [String] {
    guard brickNames.count >= 2 else {
        assertionFailure("Should almost have two views to do a equally layout")
        return []
    }

    return brickNames.enumerate().flatMap { (index: Int, element: String) -> String? in
        if index < brickNames.count - 1 {
            return "\(axis == .Horizontal ? "H" : "V"):[\(element)(\(brickNames[index + 1]))]"
        }
        return nil
    }
}

private func distribute(fromSuperview fromSuperview: Bool, metric1: Metrics?, views: [String], interspace: Metrics?, metric2: Metrics?, toSuperview: Bool) -> String{

    var format = ""

    if fromSuperview {
        format = format + "|"
        if let left = metric1 {
            format = format + left.description
        }
    }


    for viewName in views {
        format = format + "[\(viewName)]"

        if let spaceH = interspace where viewName != views.last {
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