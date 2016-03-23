//
//  JSONConvertible.swift
//  LeeGo
//
//  Created by Victor WANG on 20/03/16.
//
//

import Foundation

public typealias JSONObject = AnyObject
public typealias JSONDictionary = [String: AnyObject]

protocol JSONKeyType {
    var asString: String { get }
}

extension JSONKeyType {
    var asString: String {
        return String(self)
    }
}

protocol Encodable {
    func encode() -> JSONDictionary?
}

protocol Decodable {
    init?(json: [String: AnyObject])
}

extension Layout: Encodable, Decodable {

    private enum JSONKey: JSONKeyType {
        case formats, options, metrics
    }

    public init?(json: JSONDictionary) {
        let formats: [String] = (try? json.parse(JSONKey.formats)) ?? []
        let options: NSLayoutFormatOptions = (try? json.parse(JSONKey.options)) ?? .DirectionLeadingToTrailing
        let metrics: [String: CGFloat] = (try? json.parse(JSONKey.metrics)) ?? [:]

        self.init(formats, options: options, metrics: LayoutMetrics(customMetrics: metrics))
    }

    public func encode() -> JSONDictionary? {
        return [:]
    }
}


extension Appearance: Encodable, Decodable {

    private enum JSONKey: JSONKeyType {
        case userInteractionEnabled, translatesAutoresizingMaskIntoConstraints, backgroundColor, tintColor, tintAdjustmentMode, cornerRadius, borderWidth, borderColor, multipleTouchEnabled, exclusiveTouch, clipsToBounds, alpha, opaque, clearsContextBeforeDrawing, hidden, contentMode

        // UIControl
        case enabled, selected, highlighted

        // UILabel & UITextView & UITextField
        case font, textColor, textAlignment, numberOfLines, lineBreakMode, selectedRange, editable, selectable, dataDetectorTypes, allowsEditingTextAttributes, clearsOnInsertion, textContainerInset, linkTextAttributes, lineFragmentPadding, minimumScaleFactor, adjustsFontSizeToFitWidth, baselineAdjustment, shadowColor, shadowOffset, highlightedTextColor

        case attributedText

        case text, borderStyle, defaultTextAttributes, placeholder, attributedPlaceholder, clearsOnBeginEditing, background, disabledBackground, typingAttributes, clearButtonMode

        // UIButton
        case buttonType, buttonTitle, buttonTitleColor, buttonTitleShadowColor, buttonImage, buttonBackgroundImage, buttonAttributedTitle, contentEdgeInsets, titleEdgeInsets, reversesTitleShadowWhenHighlighted, imageEdgeInsets, adjustsImageWhenHighlighted, adjustsImageWhenDisabled, showsTouchWhenHighlighted

        // UIImageView
        case ratio

        // UIScrollView
        case scrollEnabled, contentOffset, contentSize, contentInset, directionalLockEnabled, bounces, alwaysBounceVertical, alwaysBounceHorizontal, pagingEnabled, showsHorizontalScrollIndicator, showsVerticalScrollIndicator, scrollIndicatorInsets, indicatorStyle, decelerationRate, delaysContentTouches, canCancelContentTouches, minimumZoomScale, maximumZoomScale, zoomScale, bouncesZoom, scrollsToTop, keyboardDismissMode
    }

    public init?(json: JSONDictionary) {

        guard let tuple = json.first else {
            return nil
        }

        self = .none

        switch tuple {
        case let (JSONKey.userInteractionEnabled.asString, value as Bool):
            self = .userInteractionEnabled(value)
        case let (JSONKey.translatesAutoresizingMaskIntoConstraints.asString, value as Bool):
            self = .translatesAutoresizingMaskIntoConstraints(value)
        case let (JSONKey.backgroundColor.asString, value as String):
            self = .backgroundColor(UIColor(hexString: value))
        case let (JSONKey.tintColor.asString, value as String):
            self = .tintColor(UIColor(hexString: value))
        case let (JSONKey.tintAdjustmentMode.asString, value as String):
            self = .tintAdjustmentMode(UIViewTintAdjustmentMode(mode: value))
        case let (JSONKey.cornerRadius.asString, value as CGFloat):
            self = .cornerRadius(value)
        case let (JSONKey.borderWidth.asString, value as CGFloat):
            self = .borderWidth(value)
        case let (JSONKey.multipleTouchEnabled.asString, value as Bool):
            self = .multipleTouchEnabled(value)
        case let (JSONKey.exclusiveTouch.asString, value as Bool):
            self = .exclusiveTouch(value)
        case let (JSONKey.clipsToBounds.asString, value as Bool):
            self = .clipsToBounds(value)
        case let (JSONKey.alpha.asString, value as CGFloat):
            self = .alpha(value)
        case let (JSONKey.clearsContextBeforeDrawing.asString, value as Bool):
            self = .clearsContextBeforeDrawing(value)
        case let (JSONKey.hidden.asString, value as Bool):
            self = .hidden(value)
        case let (JSONKey.contentMode.asString, value as String):
            self = .contentMode(UIViewContentMode(mode: value))

        case let (JSONKey.enabled.asString, value as Bool):
            self = .enabled(value)
        case let (JSONKey.selected.asString, value as Bool):
            self = .selected(value)
        case let (JSONKey.highlighted.asString, value as Bool):
            self = .highlighted(value)

        case let (JSONKey.font.asString, value as JSONDictionary):
            if let font = UIFont(json: value) {
                self = .font(font)
            }
        case let (JSONKey.textColor.asString, value as String):
            self = .textColor(UIColor(hexString: value))
        case let (JSONKey.textAlignment.asString, value as String):
            self = .textAlignment(NSTextAlignment(align: value))
        case let (JSONKey.numberOfLines.asString, value as Int):
            self = .numberOfLines(value)
        case let (JSONKey.lineBreakMode.asString, value as String):
            self = .lineBreakMode(NSLineBreakMode(mode: value))
        case let (JSONKey.selectedRange.asString, value as [Int]):
            self = .selectedRange(NSRange(range: value))

        default:
            assertionFailure("Can't decode json \(json) to Appearance")
        }
    }

    public func encode() -> JSONDictionary? {
        switch self {
        case let .userInteractionEnabled(enabled):
            return [JSONKey.userInteractionEnabled.asString: enabled]
        default:
            break
        }

        return nil
    }
}

extension NSLineBreakMode {
    private enum JSONKey: JSONKeyType {
        case ByWordWrapping // Wrap at word boundaries, default
        case ByCharWrapping // Wrap at character boundaries
        case ByClipping // Simply clip
        case ByTruncatingHead // Truncate at head of line: "...wxyz"
        case ByTruncatingTail // Truncate at tail of line: "abcd..."
        case ByTruncatingMiddle // Truncate middle of line:  "ab...yz"
    }

    init(mode: String) {
        switch mode {
        case JSONKey.ByWordWrapping.asString:
            self = .ByWordWrapping
        case JSONKey.ByCharWrapping.asString:
            self = .ByCharWrapping
        case JSONKey.ByClipping.asString:
            self = .ByClipping
        case JSONKey.ByTruncatingHead.asString:
            self = .ByTruncatingHead
        case JSONKey.ByTruncatingTail.asString:
            self = .ByTruncatingTail
        case JSONKey.ByTruncatingMiddle.asString:
            self = .ByTruncatingMiddle
        default:
            self = .ByWordWrapping
        }
    }

    var asString: String {
        switch self {
        case .ByWordWrapping:
            return JSONKey.ByWordWrapping.asString
        case .ByCharWrapping:
            return JSONKey.ByCharWrapping.asString
        case .ByClipping:
            return JSONKey.ByClipping.asString
        case .ByTruncatingHead:
            return JSONKey.ByTruncatingHead.asString
        case .ByTruncatingTail:
            return JSONKey.ByTruncatingTail.asString
        case .ByTruncatingMiddle:
            return JSONKey.ByTruncatingMiddle.asString
        }
    }

}

extension NSTextAlignment {
    private enum JSONKey: JSONKeyType {
        case Left // Visually left aligned

        case Center // Visually centered
        case Right // Visually right aligned
        case Justified // Fully-justified. The last line in a paragraph is natural-aligned.
        case Natural // Indicates the default alignment for script
    }

    init(align: String) {
        switch align {
        case JSONKey.Left.asString:
            self = .Left
        case JSONKey.Center.asString:
            self = .Center
        case JSONKey.Justified.asString:
            self = .Justified
        case JSONKey.Right.asString:
            self = .Right
        case JSONKey.Natural.asString:
            self = .Natural
        default:
            self = .Natural
        }
    }

    var asString: String {
        switch self {
        case .Left:
            return JSONKey.Left.asString
        case .Center:
            return JSONKey.Center.asString
        case .Justified:
            return JSONKey.Justified.asString
        case .Right:
            return JSONKey.Right.asString
        case .Natural:
            return JSONKey.Natural.asString
        }
    }
}

extension UIViewContentMode {

    private enum JSONKey: JSONKeyType {
        case ScaleToFill
        case ScaleAspectFit // contents scaled to fit with fixed aspect. remainder is transparent
        case ScaleAspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
        case Redraw // redraw on bounds change (calls -setNeedsDisplay)
        case Center // contents remain same size. positioned adjusted.
        case Top
        case Bottom
        case Left
        case Right
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }

    init(mode: String) {
        switch mode {
        case JSONKey.Bottom.asString:
            self = .Bottom
        case JSONKey.BottomLeft.asString:
            self = .BottomLeft
        case JSONKey.BottomRight.asString:
            self = .BottomRight
        case JSONKey.Center.asString:
            self = .Center
        case JSONKey.Left.asString:
            self = .Left
        case JSONKey.Redraw.asString:
            self = .Redraw
        case JSONKey.Right.asString:
            self = .Right
        case JSONKey.ScaleAspectFill.asString:
            self = .ScaleAspectFill
        case JSONKey.ScaleAspectFit.asString:
            self = .ScaleAspectFit
        case JSONKey.ScaleToFill.asString:
            self = .ScaleToFill
        case JSONKey.Top.asString:
            self = .Top
        case JSONKey.TopLeft.asString:
            self = .TopLeft
        case JSONKey.TopRight.asString:
            self = .TopRight
        default:
            self = .ScaleToFill
        }
    }

    var asString: String {
        switch self {
        case .Bottom:
            return JSONKey.Bottom.asString
        case .BottomLeft:
            return JSONKey.BottomLeft.asString
        case .BottomRight:
            return JSONKey.BottomRight.asString
        case .Center:
            return JSONKey.Center.asString
        case .Left:
            return JSONKey.Left.asString
        case .Redraw:
            return JSONKey.Redraw.asString
        case .Right:
            return JSONKey.Right.asString
        case .ScaleAspectFill:
            return JSONKey.ScaleAspectFill.asString
        case .ScaleAspectFit:
            return JSONKey.ScaleAspectFit.asString
        case .ScaleToFill:
            return JSONKey.ScaleToFill.asString
        case .Top:
            return JSONKey.Top.asString
        case .TopLeft:
            return JSONKey.TopLeft.asString
        case .TopRight:
            return JSONKey.TopRight.asString
        }
    }

}

extension UIViewTintAdjustmentMode {

    enum JSONKey: JSONKeyType {
        case Automatic

        case Normal
        case Dimmed
    }

    init(mode: String) {
        switch mode {
        case JSONKey.Automatic.asString:
            self = .Automatic
        case JSONKey.Normal.asString:
            self = .Normal
        case JSONKey.Dimmed.asString:
            self = .Dimmed
        default:
            self = .Automatic
        }
    }

    var asString: String {
        switch self {
        case .Automatic:
            return JSONKey.Automatic.asString
        case .Normal:
            return JSONKey.Normal.asString
        case .Dimmed:
            return JSONKey.Dimmed.asString
        }
    }
}


extension NSRange {

    init(range: [Int]) {
        guard range.count == 2 else {
            self.init(location: 0, length: 0)
            return
        }

        self.init(location: range[0], length: range[1])
    }

    public func encode() -> [Int] {
        return [location, length]
    }
}

extension UIEdgeInsets {

    init(insets: [CGFloat]) {
        guard insets.count == 4 else {
            self.init(top: 0, left: 0, bottom: 0, right: 0)
            return
        }

        self.init(top: insets[0], left: insets[1], bottom: insets[2], right: insets[3])
    }

    public func encode() -> [CGFloat] {
        return [top, left, bottom, right]
    }
}

extension UIFont {

    private enum JSONKey: JSONKeyType {
        case name, size
    }

    convenience init?(json: [String: AnyObject]) {
        do {
            let fontName: String = try json.parse(JSONKey.name)
            let size: CGFloat = try json.parse(JSONKey.size)
            self.init(name: fontName, size: size)
        } catch {
            return nil
        }
    }

    public func encode() -> JSONDictionary? {
        return [JSONKey.name.asString: self.fontName, JSONKey.size.asString: self.pointSize]
    }
}

extension UIColor {

    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    public func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
}

extension UIImage {
    private enum JSONKey: JSONKeyType {
        case name, data
    }

    convenience init?(json: JSONDictionary) {
        if let imageName: String = try? json.parse(JSONKey.name) {
            self.init(named: imageName)
        } else if let base64String: String = try? json.parse(JSONKey.data),
            let data = NSData(base64EncodedString: base64String, options: .IgnoreUnknownCharacters) {
            self.init(data: data)
        } else {
            return nil
        }
    }

    public func encode() -> JSONDictionary? {
        if let data = UIImagePNGRepresentation(self) {
            return [JSONKey.data.asString: data.base64EncodedDataWithOptions(.Encoding64CharacterLineLength)]
        }

        return nil
    }
}

//extension Dictionary {
//    subscript(key: JSONKeyType) -> AnyObject {
//        get {
//            return self[key.asString as! Key]
//        }
//        set (newValue) {
//
//        }
//    }
//}

extension Dictionary {

    func parse<T>(key: JSONKeyType) throws -> T {
        return try parse(key.asString)
    }

    func parse<T>(key: String) throws -> T {
        if let value = self[key as! Key] {
            if let valueWithExpectedType = value as? T {
                return valueWithExpectedType
            } else {
                throw JSONParseError.MismatchedTypeError
            }
        } else {
            throw JSONParseError.UnexpectedKeyError
        }
    }

    func parse<T>(key: JSONKeyType, defaultValue: T) -> T {
        return parse(key.asString, defaultValue: defaultValue)
    }

    func parse<T>(key: String, defaultValue: T) -> T {
        if let value = self[key as! Key] as? T {
            return value
        }
        
        return defaultValue
    }
}