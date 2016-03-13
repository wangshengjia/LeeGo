//
//  Configurations.swift
//  Pods
//
//  Created by Victor WANG on 10/01/16.
//
//

import Foundation

// public typealias MetricsValuesType = (AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject)

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

public struct Layout: Equatable {

    let formats: [String]
    let options: NSLayoutFormatOptions
    let metrics: LayoutMetrics

    public init(_ formats: [String] = [], options: NSLayoutFormatOptions = .DirectionLeadingToTrailing, metrics: LayoutMetrics = LayoutMetrics()) {
        self.formats = formats
        self.metrics = metrics
        self.options = options
    }
}

public func ==(lhs: Layout, rhs: Layout) -> Bool {
    return lhs.formats == rhs.formats && lhs.metrics == rhs.metrics && lhs.options == rhs.options
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

public enum Appearance {
    // UIView
    case userInteractionEnabled(Bool), translatesAutoresizingMaskIntoConstraints(Bool), backgroundColor(UIColor), tintColor(UIColor), tintAdjustmentMode(UIViewTintAdjustmentMode), cornerRadius(CGFloat), borderWidth(CGFloat), borderColor(UIColor), multipleTouchEnabled(Bool), exclusiveTouch(Bool), clipsToBounds(Bool), alpha(CGFloat), opaque(Bool), clearsContextBeforeDrawing(Bool), hidden(Bool), contentMode(UIViewContentMode)

    // UIControl
    case enabled(Bool), selected(Bool), highlighted(Bool), contentVerticalAlignment(UIControlContentVerticalAlignment), contentHorizontalAlignment(UIControlContentHorizontalAlignment)

    // UILabel & UITextView
    case font(UIFont), textColor(UIColor), textAlignment(NSTextAlignment), numberOfLines(Int), lineBreakMode(NSLineBreakMode), defaultLabelText(String), selectedRange(NSRange), editable(Bool), selectable(Bool), dataDetectorTypes(UIDataDetectorTypes), allowsEditingTextAttributes(Bool), clearsOnInsertion(Bool), textContainerInset(UIEdgeInsets), linkTextAttributes(Attributes)
    case attributedText([Attributes]) // TODO: handle also NSParagrapheStyle

    // UIButton
    case buttonType(UIButtonType), buttonTitle(String, UIControlState), buttonTitleColor(UIColor, UIControlState), buttonTitleShadowColor(UIColor, UIControlState), buttonImage(UIImage, UIControlState), buttonBackgroundImage(UIImage, UIControlState), buttonAttributedTitle([Attributes], UIControlState), contentEdgeInsets(UIEdgeInsets), titleEdgeInsets(UIEdgeInsets), reversesTitleShadowWhenHighlighted(Bool), imageEdgeInsets(UIEdgeInsets), adjustsImageWhenHighlighted(Bool), adjustsImageWhenDisabled(Bool), showsTouchWhenHighlighted(Bool)

    // UIImageView
    case ratio(CGFloat)

    // UIScrollView
    case scrollEnabled(Bool)

    // UITextField
    // ...

    // Custom
    case custom([String: AnyObject])
    case none

    func apply<Component: UIView>(to component: Component, useDefaultValue: Bool = false) {

        switch (self, component) {
        // UIView
        case (let .backgroundColor(color), _):
            component.backgroundColor = useDefaultValue ? nil : color
        case (let .userInteractionEnabled(userInteractionEnabled), _):
            component.userInteractionEnabled = userInteractionEnabled
        case (let .translatesAutoresizingMaskIntoConstraints(should), _):
            component.translatesAutoresizingMaskIntoConstraints = should
        case (let .tintColor(color), _):
            component.tintColor = color
        case (let .tintAdjustmentMode(mode), _):
            component.tintAdjustmentMode = mode
        case (let .cornerRadius(radius), _):
            component.layer.cornerRadius = radius
        case (let .borderWidth(borderWidth), _):
            component.layer.borderWidth = borderWidth
        case (let .borderColor(borderColor), _):
            component.layer.borderColor = borderColor.CGColor
        case (let .multipleTouchEnabled(multipleTouchEnabled), _):
            component.multipleTouchEnabled = multipleTouchEnabled
        case (let .exclusiveTouch(exclusiveTouch), _):
            component.exclusiveTouch = exclusiveTouch
        case (let .clipsToBounds(clipsToBounds), _):
            component.clipsToBounds = clipsToBounds
        case (let .alpha(alpha), _):
            component.alpha = alpha
        case (let .opaque(opaque), _):
            component.opaque = opaque
        case (let .hidden(hidden), _):
            component.hidden = hidden
        case (let .clearsContextBeforeDrawing(clearsContextBeforeDrawing), _):
            component.clearsContextBeforeDrawing = clearsContextBeforeDrawing
        case (let .contentMode(contentMode), _):
            component.contentMode = contentMode

        // UIControl
        case (let .enabled(enabled), let control as UIControl):
            control.enabled = enabled
        case (let .selected(selected), let control as UIControl):
            control.selected = selected
        case (let .highlighted(highlighted), let control as UIControl):
            control.highlighted = highlighted
        case (let .contentVerticalAlignment(contentVerticalAlignment), let control as UIControl):
            control.contentVerticalAlignment = contentVerticalAlignment
        case (let .contentHorizontalAlignment(contentHorizontalAlignment), let control as UIControl):
            control.contentHorizontalAlignment = contentHorizontalAlignment

        // UILabel
        case (let .font(font), let label as UILabel):
            label.font = font
        case (let .textColor(color), let label as UILabel):
            label.textColor = color
        case (let .textAlignment(align), let label as UILabel):
            label.textAlignment = align
        case (let .numberOfLines(number), let label as UILabel):
            label.numberOfLines = number
        case (let .defaultLabelText(text), let label as UILabel):
            label.text = text
        case (let .attributedText(attributes), let label as UILabel):
            label.attributedText = attributedStringFromList(attributes)

        // UITextView
        case (let .selectedRange(range), let textView as UITextView):
            textView.selectedRange = range
        case (let .editable(editable), let textView as UITextView):
            textView.editable = editable
        case (let .selectable(selectable), let textView as UITextView):
            textView.selectable = selectable
        case (let .dataDetectorTypes(types), let textView as UITextView):
            textView.dataDetectorTypes = types
        case (let .allowsEditingTextAttributes(allows), let textView as UITextView):
            textView.allowsEditingTextAttributes = allows
        case (let .clearsOnInsertion(clearsOnInsertion), let textView as UITextView):
            textView.clearsOnInsertion = clearsOnInsertion
        case (let .textContainerInset(inset), let textView as UITextView):
            textView.textContainerInset = inset
        case (let .linkTextAttributes(attrs), let textView as UITextView):
            textView.linkTextAttributes = attrs

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

        // UIImageView
        case (let .ratio(ratioValue), let image as UIImageView):
            let id = "ratio(width == height * \(ratioValue))"
            if !useDefaultValue {
                let constraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: image, attribute: NSLayoutAttribute.Height, multiplier: ratioValue, constant: 0)
                constraint.identifier = id
                constraint.priority = 990
                image.addConstraint(constraint)
            } else {
                image.removeConstraints(image.constraints.filter({ (constraint) -> Bool in
                    return constraint.identifier == id
                }))
            }

        // UIScrollView
        case (let .scrollEnabled(scrollEnabled), let scrollView as UIScrollView):
            scrollView.scrollEnabled = scrollEnabled

        // Multiple
        case (let .lineBreakMode(mode), _):
            if component.respondsToSelector("setLineBreakMode:") {
                component.setValue(mode.rawValue.nsObject(), forKey: toString())
            } else {
                assertionFailure("Unknown appearance \(self) for component \(component)")
            }
            
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


    func toString() -> String {
        let strSelf = String(self)
        if let index = strSelf.characters.indexOf("(") {
            return String(self).substringToIndex(index)
        }
        return strSelf
    }

    private func attributedStringFromList(attrList: [Attributes]) -> NSAttributedString? {
        return attrList.flatMap({ (attribute) -> NSAttributedString? in
            // TODO: is that possible to take care this default "space" ??
            return NSAttributedString(string: (attribute[kCustomAttributeDefaultText] as? String) ?? " ", attributes: attribute)
        }).combineToAttributedString()
    }
}

extension Appearance: Hashable, Equatable {
    public var hashValue: Int {
        return self.toString().hashValue
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






