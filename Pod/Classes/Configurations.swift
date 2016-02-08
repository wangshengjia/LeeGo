//
//  Configurations.swift
//  Pods
//
//  Created by Victor WANG on 10/01/16.
//
//

import Foundation

// Configurations

// public typealias StyleType = [Appearance: AnyObject]

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

public typealias MetricsValuesType = (AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject)

public struct Layout {

    let formats: [String]
    let metrics: [String: AnyObject]?

    public init(_ formats: [String] = [], _ metrics: [String: AnyObject] = ["top" : 0, "left": 0, "bottom": 0, "right": 0, "interspaceH": 0, "interspaceV": 0]) {
        self.formats = formats
        self.metrics = metrics
    }

    public init(_ formats: [String] = [], _ metrics: MetricsValuesType) {
        self.formats = formats
        self.metrics = [
            "top" : metrics.0,
            "left": metrics.1,
            "bottom": metrics.2,
            "right": metrics.3,
            "interspaceH": metrics.4,
            "interspaceV": metrics.5,
        ]
    }
}

//public struct Configuration {
//    public let style: [Appearance]
//    public let components: [ComponentTarget: Configuration]?
//    public let layout: Layout?
//
//    public init(_ style: [Appearance] = [], _ components: [ComponentTarget: Configuration]? = nil, _ layout: Layout? = nil) {
//
//        // check is two components have the same name
//
//        self.style = style
//        self.components = components
//        self.layout = layout
//    }
//
//    public init(go1 style: [Appearance] = [], _ components: [ComponentTarget]? = nil, _ layout: (c1: String, c2: String) -> (Layout?)) {
//        self.style = style
//        self.components = nil
//        self.layout = layout(c1: (components?[0].name)!, c2: (components?[1].name)!)
//    }
//
//    public init(go style1: [Appearance] = [], _ components: [ComponentTarget]? = nil, _ layout: (components: [String]) -> (Layout?)) {
//        self.style = style1
//        self.components = nil
//        self.layout = layout(components: components?.map({ (component) -> String in
//            return component.name
//        }) ?? [])
//    }
//
//}

///// A type of dictionary that only uses strings for keys and can contain any
///// type of object as a value.
//public typealias JSONDictionary = [String: JSONObject]
//
///// A type of any object
//public typealias JSONObject = AnyObject

extension Int {
    func nsObject() -> NSNumber {
        return NSNumber(integer: self)
    }
}

extension Bool {
    func nsObject() -> NSNumber {
        return NSNumber(bool: self)
    }
}

public enum Appearance: Equatable {
    case font(UIFont), textColor(UIColor), backgroundColor(UIColor), textAlignment(NSTextAlignment), numberOfLines(Int), translatesAutoresizingMaskIntoConstraints(Bool)
    case attributedString([[String: AnyObject]])
    case custom((String, AnyObject))
    case none

    func toString() -> String {
        let strSelf = String(self)
        if let index = strSelf.characters.indexOf("(") {
            return String(self).substringToIndex(index)
        }
        return strSelf
    }

    func tuple() -> (key: String, value: AnyObject)? {

        switch self {
        case let .font(font):
            return (key: toString(), value: font)
        case let .textColor(color):
            return (key: toString(), value: color)
        case let .backgroundColor(color):
            return (key: toString(), value: color)
        case let .textAlignment(align):
            return (key: toString(), value: align.rawValue.nsObject())
        case let .numberOfLines(number):
            return (key: toString(), value: number.nsObject())
        case let .translatesAutoresizingMaskIntoConstraints(should):
            return (key: toString(), value: should.nsObject())
        case let .attributedString(attrList):
            return (key: toString(), value: attrList)
        case let .custom(dictionary):
            return dictionary
        default:
            break
        }

        return nil
    }

    static func tuples(styles: [Appearance]) -> [(key: String, value: AnyObject)] {
        return styles.flatMap({ (appearance) -> (key: String, value: AnyObject)? in
            return appearance.tuple()
        })
    }

    static func dictionary(styles: [Appearance]) -> [String: AnyObject] {
        var result = [String: AnyObject]()
        for appearance in styles {
            switch appearance {
            case let .font(font):
                result[""] = font
            default:
                break
            }
        }
        
        return result
    }

    var isCustom: Bool {
        if case .custom(_) = self {
            return true
        }
        return false
    }

    var isAttributedString: Bool {
        if case .attributedString(_) = self {
            return true
        }
        return false
    }
//    public var hashValue: Int {
//        return String(self).hashValue
//    }
}

public func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    if let result1 = lhs.tuple(), let result2 = rhs.tuple() {
        return result1.key == result2.key && result1.value.isEqual(result2.value)
    }

    return false
}


//extension ConfigurationType {
//
//}

protocol Decodable {}
protocol Encodable {}






