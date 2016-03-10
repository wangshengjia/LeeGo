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
    case Fill, FillEqually, Flow(UInt)
}

public func layoutHorizontal(components: [String], align: Alignment = .Top, distribution: Distribution, metrics: MetricsValuesType) -> Layout {
    guard !components.isEmpty else {
        assertionFailure("Components should not be empty")
        return Layout()
    }

    switch distribution {
    case .Fill:
        let formatH = H(orderedViews:components)
        switch align {
        case .Top:
            return Layout([formatH] + components.map { (component) -> String in
                V(orderedViews:[component], bottom:.bottom(.GreaterThanOrEqual))
                }, metrics)
        case .Bottom:
            return Layout([formatH] + components.map { (component) -> String in
                V(top:.top(.GreaterThanOrEqual), orderedViews:[component])
                }, metrics)
        case .Fill:
            return Layout([formatH] + components.map { (component) -> String in
                V(orderedViews:[component])
                }, metrics)
        case .Center:
            // TODO: center also with superview
            return Layout([formatH] + components.map { (component) -> String in
                V(top:.top(.GreaterThanOrEqual), orderedViews:[component], bottom:.bottom(.GreaterThanOrEqual))
                }, options: .AlignAllCenterY, metrics)
        default:
            assertionFailure("")
            break
        }
        break
    case .FillEqually:
        break
    case let .Flow(index):
        break
    }

    return Layout()
}

func HFlowLayout(left:[String] = [], right:[String] = []) -> [String] {
    if left.isEmpty && right.isEmpty {
        assertionFailure("Should not be empty")
        return []
    }

    var formatH = ""

    if left.isEmpty {
        formatH = H(left: .left(.GreaterThanOrEqual), orderedViews:right)
    } else if right.isEmpty {
        formatH = H(orderedViews:left, right: .right(.GreaterThanOrEqual))
    } else {
        formatH = H(orderedViews:left, toSuperview: false) + Metrics.interspaceH(.GreaterThanOrEqual).description + H(fromSuperview: false, orderedViews:right)
    }

    return [formatH] + (left + right).map { (component) -> String in
        V(orderedViews:[component])
    }
}

func VFlowLayout(top:[String] = [], bottom:[String] = []) -> [String] {
    if top.isEmpty && bottom.isEmpty {
        assertionFailure("")
        return []
    }

    var formatV = ""

    if top.isEmpty {
        formatV = V(top: .top(.GreaterThanOrEqual), orderedViews:bottom)
    } else if bottom.isEmpty {
        formatV = V(orderedViews:top, bottom: .bottom(.GreaterThanOrEqual))
    } else {
        formatV = V(orderedViews:top, toSuperview: false) + Metrics.interspaceV(.GreaterThanOrEqual).description + V(fromSuperview: false, orderedViews:bottom)
    }

    return [formatV] + (top + bottom).map { (component) -> String in
        H(orderedViews:[component])
    }
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