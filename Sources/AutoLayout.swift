//
//  AutoLayout.swift
//  Pods
//
//  Created by Victor WANG on 04/02/16.
//
//

import Foundation

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
    case top(NSLayoutRelation), bottom(NSLayoutRelation), left(NSLayoutRelation), right(NSLayoutRelation), interspaceH(NSLayoutRelation), interspaceV(NSLayoutRelation), none, custom(String)


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
        case let .interspaceH(relation):
            return relation == .Equal ? "-interspaceH-" : "-(\(relation)interspaceH)-"
        case let .interspaceV(relation):
            return relation == .Equal ? "-interspaceV-" : "-(\(relation)interspaceV)-"
        default:
            break
        }
        return ""
    }
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

extension Layout {

}

public func layout(components: [String], axis: Axis, align: Alignment, distribution: Distribution, metrics: MetricsValuesType = (0, 0, 0, 0, 0, 0)) -> Layout {
    guard !components.isEmpty else {
        assertionFailure("Components should not be empty")
        return Layout()
    }

    let formats = formatHorizontal(components, axis: axis, align: align, distribution: distribution) + formatVertical(components, axis: axis, align: align, distribution: distribution)
    let options = layoutOptions(components, axis: axis, align: align, distribution: distribution)
    return Layout(formats, options: options, metrics)
}

public func H(fromSuperview fromSuperview: Bool = true, left: Metrics? = .left(.Equal), orderedViews: [String] = [], interspace: Metrics? = .interspaceH(.Equal), right: Metrics? = .right(.Equal), toSuperview: Bool = true) -> String {
    guard !orderedViews.isEmpty else {
        assertionFailure("Should at least with 1 view name")
        return ""
    }

    return "H:" + distribute(fromSuperview: fromSuperview, metric1: left, views: orderedViews, interspace: interspace, metric2: right, toSuperview: toSuperview)
}

//public func H(fromSuperview fromSuperview: Bool = true, left: Metrics? = .left(.Equal), orderedViews: String..., interspace: Metrics? = .interspaceH(.Equal), right: Metrics? = .right(.Equal), toSuperview: Bool = true) -> String {
//
//    return H(fromSuperview: fromSuperview, left: left, orderedViews: orderedViews, interspace: interspace, right: right, toSuperview: toSuperview)
//}

public func V(fromSuperview fromSuperview: Bool = true, top: Metrics? = .top(.Equal), orderedViews: [String] = [], interspace: Metrics? = .interspaceV(.Equal), bottom: Metrics? = .bottom(.Equal), toSuperview: Bool = true) -> String {
    guard !orderedViews.isEmpty else {
        assertionFailure("Should at least with 1 view name")
        return ""
    }

    return "V:" + distribute(fromSuperview: fromSuperview, metric1: top, views: orderedViews, interspace: interspace, metric2: bottom, toSuperview: toSuperview)
}

public func H(view: String, width: Double) -> String {
    return "H:[\(view)(\(width))]"
}

public func V(view: String, height: Double) -> String{
    return "V:[\(view)(\(height))]"
}

public func H(customVFL: String) -> String {
    return "H:\(customVFL)"
}

public func V(customVFL: String) -> String {
    return "V:\(customVFL)"
}

// MARK: Private

private func formatHorizontal(components: [String], axis: Axis, align: Alignment, distribution: Distribution) -> [String] {
    guard !components.isEmpty else {
        assertionFailure("Components should not be empty")
        return []
    }

    if axis == .Horizontal {
        switch distribution {
        case .Fill:
            return [H(orderedViews:components)]
        case .FillEqually:
            return [H(orderedViews: components)] + equallyLayoutFormats(components, axis: .Horizontal)
        case let .Flow(index):
            let left = Array(components.prefix(min(max(index, 0), components.count)))
            let right = Array(components.suffix(min(max(components.count - index, 0), components.count)))

            if left.isEmpty {
                return [H(left: .left(.GreaterThanOrEqual), orderedViews:right)]
            } else if right.isEmpty {
                return [H(orderedViews:left, right: .right(.GreaterThanOrEqual))]
            } else {
                let str = H(fromSuperview: false, orderedViews:right)
                let index = str.startIndex.advancedBy(2)
                return [H(orderedViews:left, toSuperview: false) + Metrics.interspaceH(.GreaterThanOrEqual).description + str.substringFromIndex(index)]
            }
        }
    } else {
        return components.flatMap { (component) -> String? in

            switch align {
            case .Left:
                return H(orderedViews:[component], right:.right(.GreaterThanOrEqual))
            case .Right:
                return H(left:.left(.GreaterThanOrEqual), orderedViews:[component])
            case .Fill:
                return H(orderedViews:[component])
            case .Center:
                // TODO: center also with superview
                return H(left:.left(.GreaterThanOrEqual), orderedViews:[component], right:.right(.GreaterThanOrEqual))
            default:
                assertionFailure("")
                return nil
            }
        }
    }
}

private func formatVertical(components: [String], axis: Axis, align: Alignment, distribution: Distribution) -> [String] {
    guard !components.isEmpty else {
        assertionFailure("Components should not be empty")
        return []
    }

    if axis == .Horizontal {
        return components.flatMap { (component) -> String? in

            switch align {
            case .Top:
                return V(orderedViews:[component], bottom:.bottom(.GreaterThanOrEqual))
            case .Bottom:
                return V(top:.top(.GreaterThanOrEqual), orderedViews:[component])
            case .Fill:
                return V(orderedViews:[component])
            case .Center:
                // TODO: center also with superview
                return V(top:.top(.GreaterThanOrEqual), orderedViews:[component], bottom:.bottom(.GreaterThanOrEqual))
            default:
                assertionFailure("")
                return nil
            }
        }
    } else {
        switch distribution {
        case .Fill:
            return [V(orderedViews:components)]
        case .FillEqually:
            return [V(orderedViews: components)] + equallyLayoutFormats(components, axis: .Vertical)
        case let .Flow(index):
            let top = Array(components.prefix(min(max(index, 0), components.count)))
            let bottom = Array(components.suffix(min(max(components.count - index, 0), components.count)))

            if top.isEmpty {
                return [V(top: .top(.GreaterThanOrEqual), orderedViews:bottom)]
            } else if bottom.isEmpty {
                return [V(orderedViews: top, bottom: .bottom(.GreaterThanOrEqual))]
            } else {
                let str = V(fromSuperview: false, orderedViews:bottom)
                let index = str.startIndex.advancedBy(2)
                return [V(orderedViews: top, toSuperview: false) + Metrics.interspaceV(.GreaterThanOrEqual).description + str.substringFromIndex(index)]
            }
        }
    }
}

private func layoutOptions(components: [String], axis: Axis, align: Alignment, distribution: Distribution) -> NSLayoutFormatOptions {
    if axis == .Horizontal && align == .Center {
        return [.AlignAllCenterY, .DirectionLeadingToTrailing]
    }

    if axis == .Vertical && align == .Center {
        return [.AlignAllCenterX, .DirectionLeadingToTrailing]
    }

    // Default
    return .DirectionLeadingToTrailing
}

private func equallyLayoutFormats(views: [String], axis: Axis) -> [String] {
    guard views.count >= 2 else {
        assertionFailure("Should almost have two views to do a equally layout")
        return []
    }

    return views.enumerate().flatMap { (index: Int, element: String) -> String? in
        if index < views.count - 1 {
            return "\(axis == .Horizontal ? "H" : "V"):[\(element)(\(views[index + 1]))]"
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

        if let interspaceH = interspace where viewName != views.last {
            format = format + interspaceH.description
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