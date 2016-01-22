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

public protocol ConfigurationType {
    
    var style: StyleType { get }
    var components: [ComponentTarget: ConfigurationType]? { get }
    var layout: Layout? { get }
}

public struct Layout {
    let formats: [String]
    let metrics: [String: AnyObject]?

    public init(_ formats: [String] = [], _ metrics: [String: AnyObject]? = nil) {
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
    public let components: [ComponentTarget: ConfigurationType]?
    public let layout: Layout?

    public init(_ style: StyleType = [:], _ components: [ComponentTarget: ConfigurationType]? = nil, _ layout: Layout? = nil) {
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

public struct Configurator {
    func resolveConfiguration(element: ItemType) -> Configuration {
        
        return Configuration()
    }
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

public protocol StringConvertible {

    func rawValue() -> String
}






