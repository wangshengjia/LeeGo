//
//  Configurations.swift
//  Pods
//
//  Created by Victor WANG on 10/01/16.
//
//

import Foundation

// Configurations

public typealias StyleType = [Appearance: AnyObject]

//public protocol ConfigurationType {
//    var style: StyleType { get }
//    var components: [ComponentTarget: Self]? { get }
//    var layout: Layout? { get }
//}

//extension RawRepresentable where RawValue == String {
//    func target(targetClass: AnyObject = UIView) -> ComponentTarget {
//        return ComponentTarget(name: rawValue, targetClass: targetClass)
//    }
//}

public struct Layout {
    let formats: [String]
    let metrics: [String: AnyObject]?

    public init(_ formats: [String] = [], _ metrics: [String: AnyObject]? = nil) {
        self.formats = formats
        self.metrics = metrics
    }
}

public struct Configuration {
    public let style: StyleType
    public let components: [ComponentTarget: Configuration]?
    public let layout: Layout?

    public init(_ style: StyleType = [:], _ components: [ComponentTarget: Configuration]? = nil, _ layout: Layout? = nil) {
        self.style = style
        self.components = components
        self.layout = layout
    }

    public init(_ style: StyleType = [:], _ components: [ComponentTarget]? = nil, _ layout: (String?, String?) -> (Layout?)) {
        self.style = style
        self.components = nil
        self.layout = layout(components?[0].name, components?[1].name)
    }
}

///// A type of dictionary that only uses strings for keys and can contain any
///// type of object as a value.
//public typealias JSONDictionary = [String: JSONObject]
//
///// A type of any object
//public typealias JSONObject = AnyObject

public enum Appearance: Hashable {
    case font, textColor, backgroundColor, textAlignment, numberOfLines, translatesAutoresizingMaskIntoConstraints
    case Custom(String)

    public var hashValue: Int {
        return String(self).hashValue
    }
}

public func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    return String(lhs) == String(rhs)
}


//extension ConfigurationType {
//
//}

protocol Printable {}
protocol Decodable {}
protocol Encodable {}






