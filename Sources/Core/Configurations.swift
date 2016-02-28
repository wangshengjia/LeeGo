//
//  Configurations.swift
//  Pods
//
//  Created by Victor WANG on 10/01/16.
//
//

import Foundation

public typealias MetricsValuesType = (AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject)

public struct Layout: Equatable {

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

// implement Layout equatable protocol, naive version
public func ==(lhs: Layout, rhs: Layout) -> Bool {
    var sameMetrics = false
    if let lhsMetrics = lhs.metrics, let rhsMetrics = rhs.metrics where lhsMetrics.count == rhsMetrics.count {
        sameMetrics = true
        for (key, value) in lhsMetrics {
            if let rhsValue = rhsMetrics[key] where !rhsValue.isEqual(value) {
                sameMetrics = false
            }
        }
    } else if (lhs.metrics == nil && rhs.metrics == nil) {
        sameMetrics = true
    } else {
        sameMetrics = false
    }

    return lhs.formats == rhs.formats && sameMetrics
}

public typealias Attributes = [String: AnyObject]

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

public enum Appearance: Hashable, Equatable {
    // UIView
    case translatesAutoresizingMaskIntoConstraints(Bool), backgroundColor(UIColor), tintColor(UIColor)

    // UIControl

    // UILabel
    case font(UIFont), textColor(UIColor), textAlignment(NSTextAlignment), numberOfLines(Int), defaultLabelText(String)
    case attributedString([Attributes]) // TODO: handle also NSParagrapheStyle

    // UIButton
    case buttonType(UIButtonType), buttonTitle(String, UIControlState), buttonTitleColor(UIColor, UIControlState), buttonTitleShadowColor(UIColor, UIControlState), buttonImage(UIImage, UIControlState), buttonBackgroundImage(UIImage, UIControlState), buttonAttributedTitle([Attributes], UIControlState), contentEdgeInsets(UIEdgeInsets), titleEdgeInsets(UIEdgeInsets), reversesTitleShadowWhenHighlighted(Bool), imageEdgeInsets(UIEdgeInsets), adjustsImageWhenHighlighted(Bool), adjustsImageWhenDisabled(Bool), showsTouchWhenHighlighted(Bool)

    // UIImageView

    // UITextView
    // UITextField
    // ...

    // Custom
    case custom([String: AnyObject])
    case none

    func toString() -> String {
        let strSelf = String(self)
        if let index = strSelf.characters.indexOf("(") {
            return String(self).substringToIndex(index)
        }
        return strSelf
    }

    func apply<Component: UIView>(to component: Component, useDefaultValue: Bool = false) {

        switch (self, component) {
        // UIView
        case (let .backgroundColor(color), _):
            component.setValue(useDefaultValue ? nil : color, forKey: toString())
        case (let .translatesAutoresizingMaskIntoConstraints(should), _):
            component.setValue(should.nsObject(), forKey: toString())

        // UILabel
        case (let .font(font), let label as UILabel):
            label.setValue(font, forKey: toString())
        case (let .textColor(color), let label as UILabel):
            label.setValue(color, forKey: toString())
        case (let .textAlignment(align), let label as UILabel):
            label.setValue(align.rawValue.nsObject(), forKey: toString())
        case (let .numberOfLines(number), let label as UILabel):
            label.setValue(number.nsObject(), forKey: toString())
        case (let .defaultLabelText(text), let label as UILabel):
            label.text = text
        case (let .attributedString(attributes), let label as UILabel):
            label.attributedText = attributedStringFromList(attributes)

        // UIButton
        case (let .buttonType(type), let button as UIButton):
            print(type) //TODO:  button.buttonType = type
        case (let .buttonTitle(title, state), let button as UIButton):
            button.setTitle(title, forState: state)
        case (let .buttonTitleColor(color, state), let button as UIButton):
            button.setTitleColor(color, forState: state)
        case (let .buttonTitleShadowColor(color, state), let button as UIButton):
            button.setTitleShadowColor(color, forState: state)
        case (let .buttonImage(image, state), let button as UIButton):
            button.setImage(image, forState: state)
        case (let .buttonBackgroundImage(image, state), let button as UIButton):
            button.setBackgroundImage(image, forState: state)
        case (let .buttonAttributedTitle(attributes, state), let button as UIButton):
            button.setAttributedTitle(attributedStringFromList(attributes), forState: state)
        case (let .contentEdgeInsets(insets), let button as UIButton):
            button.contentEdgeInsets = insets
        case (let .titleEdgeInsets(insets), let button as UIButton):
            button.titleEdgeInsets = insets
        case (let .imageEdgeInsets(insets), let button as UIButton):
            button.imageEdgeInsets = insets
        case (let .reversesTitleShadowWhenHighlighted(should), let button as UIButton):
            button.reversesTitleShadowWhenHighlighted = should
        case (let .adjustsImageWhenHighlighted(should), let button as UIButton):
            button.adjustsImageWhenHighlighted = should
        case (let .adjustsImageWhenDisabled(should), let button as UIButton):
            button.adjustsImageWhenDisabled = should
        case (let .showsTouchWhenHighlighted(should), let button as UIButton):
            button.showsTouchWhenHighlighted = should

        // Custom
        case (let .custom(dictionary), _):
            useDefaultValue ? component.removeCustomStyle(dictionary) : component.setupCustomStyle(dictionary)
        default:
            assertionFailure("Unknown appearance \(self) for component \(component)")
            break
        }
    }


//    func value() -> AnyObject? {
//
//        switch self {
//        // UIView
//        case let .backgroundColor(color):
//            return color
//        case let .translatesAutoresizingMaskIntoConstraints(should):
//            return should
//
//        // UILabel
//        case let .font(font):
//            return font
//        case let .textColor(color):
//            return color
//        case let .textAlignment(align):
//            return String(align)
//        case let .numberOfLines(number):
//            return number
//        case let .defaultLabelText(text):
//            return text
//        case let .attributedString(attrList):
//            return attrList
//
//        // UIButton
//        case let .buttonTitle(title, state):
//            return title + "\(state)"
//        case let .buttonTitleColor(color, state):
//            return (color)
//        case (let .buttonTitleShadowColor(color, state), let button as UIButton):
//            button.setTitleShadowColor(color, forState: state)
//        case (let .buttonImage(image, state), let button as UIButton):
//            button.setImage(image, forState: state)
//        case (let .buttonBackgroundImage(image, state), let button as UIButton):
//            button.setBackgroundImage(image, forState: state)
//        case (let .buttonAttributedTitle(attributes, state), let button as UIButton):
//            button.setAttributedTitle(attributedStringFromList(attributes), forState: state)
//        case (let .contentEdgeInsets(insets), let button as UIButton):
//            button.contentEdgeInsets = insets
//        case (let .titleEdgeInsets(insets), let button as UIButton):
//            button.titleEdgeInsets = insets
//        case (let .imageEdgeInsets(insets), let button as UIButton):
//            button.imageEdgeInsets = insets
//        case (let .reversesTitleShadowWhenHighlighted(should), let button as UIButton):
//            button.reversesTitleShadowWhenHighlighted = should
//        case (let .adjustsImageWhenHighlighted(should), let button as UIButton):
//            button.adjustsImageWhenHighlighted = should
//        case (let .adjustsImageWhenDisabled(should), let button as UIButton):
//            button.adjustsImageWhenDisabled = should
//        case (let .showsTouchWhenHighlighted(should), let button as UIButton):
//            button.showsTouchWhenHighlighted = should
//
//        // Custom
//        case let .custom(dictionary):
//            return dictionary
//        default:
//            assertionFailure("Unknown appearance \(self)")
//            return nil
//        }
//    }

    public var hashValue: Int {
        return self.toString().hashValue
    }

    private func attributedStringFromList(attrList: [Attributes]) -> NSAttributedString? {
        return attrList.flatMap({ (attribute) -> NSAttributedString? in
            // TODO: is that possible to take care this default "space" ??
            return NSAttributedString(string: (attribute[kCustomAttributeDefaultText] as? String) ?? " ", attributes: attribute)
        }).combineToAttributedString()
    }
}

public func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    // TODO: how to implement the real equatable

//    if let result1 = lhs.value(), let result2 = rhs.value() {
//        return lhs.toString() == rhs.toString() && result1.isEqual(result2)
//    }
    return lhs.toString() == rhs.toString()
}

protocol Decodable {}
protocol Encodable {}






