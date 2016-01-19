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
//public typealias SubComponent = (ComponentTarget, ConfigurationType)

public protocol ConfigurationTargetType {
    func configuration() -> Configuration
}

public protocol ComponentTargetType {
    func availableComponentTypes() -> [String : AnyClass]
}

extension ComponentTargetType {
    func componentClass() -> AnyClass? {
        return self.availableComponentTypes()[self.stringValue]
    }

    var stringValue: String {
        return String(self)
    }
}

public protocol ConfigurationType {
    
    var style: StyleType { get }
    var components: [(ComponentTargetType, ConfigurationType)]? { get }
    var layout: Layout? { get }
}

public struct Layout {
    let formats: [String]
    let metrics: [String: AnyObject]?

    public init(formats: [String] = [], metrics: [String: AnyObject]? = nil) {
        self.formats = formats
        self.metrics = metrics
    }
}

public extension Dictionary where Key: RawRepresentable {
    func rawStyle() -> [String: Value] {
        var rawStyle = [String: Value]()
        for (appearance, value) in self {
            if let rawValue = appearance.rawValue as? String {
                rawStyle[rawValue] = value
            }
        }
        return rawStyle
    }
}

public struct Configuration: ConfigurationType {
    public let style: StyleType
    public let components: [(ComponentTargetType, ConfigurationType)]?
    public let layout: Layout?

    public init(style: StyleType = [:], components: [(ComponentTargetType, ConfigurationType)]? = nil, layout: Layout? = nil) {
        self.style = style
        self.components = components
        self.layout = layout
    }
}

// User provide?
public struct ConfigurationTarget<Configuration: ConfigurationType> {

}

/// A type of dictionary that only uses strings for keys and can contain any
/// type of object as a value.
public typealias JSONDictionary = [String: JSONObject]

/// A type of any object
public typealias JSONObject = AnyObject

public enum Appearance: String {
    case font, textColor, backgroundColor, textAlignment, numberOfLines
}

enum MyAppearance: String {
    case ThreeTwo
}

protocol Printable {}

public struct Styles {
    public static let None = StyleType()
    public static let H1: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.grayColor(), .textAlignment: NSNumber(integer:  NSTextAlignment.Center.rawValue)]
    public static let H2: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.redColor(), .numberOfLines: NSNumber(integer: 0)]
    public static let H3: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.lightGrayColor()]
    public static let I1: StyleType = [.backgroundColor: UIColor.greenColor()]
}





