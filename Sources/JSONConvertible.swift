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

extension NSLayoutFormatOptions {
    private enum JSONKey: JSONKeyType {
        case AlignAllLeft
        case AlignAllRight
        case AlignAllTop
        case AlignAllBottom
        case AlignAllLeading
        case AlignAllTrailing
        case AlignAllCenterX
        case AlignAllCenterY
        case AlignAllBaseline
        case AlignAllLastBaseline
        case AlignAllFirstBaseline
        case AlignmentMask
        case DirectionLeadingToTrailing
        case DirectionLeftToRight
        case DirectionRightToLeft
        case DirectionMask
    }

    init(options: [String]) {
        self.init(options.flatMap { (option) -> NSLayoutFormatOptions? in
            switch option {
            case JSONKey.AlignAllLeft.asString:
                return .AlignAllLeft
            case JSONKey.AlignAllRight.asString:
                return .AlignAllRight
            case JSONKey.AlignAllTop.asString:
                return .AlignAllTop
            case JSONKey.AlignAllBottom.asString:
                return .AlignAllBottom
            case JSONKey.AlignAllLeading.asString:
                return .AlignAllLeading
            case JSONKey.AlignAllTrailing.asString:
                return .AlignAllTrailing
            case JSONKey.AlignAllCenterX.asString:
                return .AlignAllCenterX
            case JSONKey.AlignAllCenterY.asString:
                return .AlignAllCenterY
            case JSONKey.AlignAllBaseline.asString:
                return .AlignAllBaseline
            case JSONKey.AlignAllLastBaseline.asString:
                return .AlignAllLastBaseline
            case JSONKey.AlignAllFirstBaseline.asString:
                return .AlignAllFirstBaseline
            case JSONKey.AlignmentMask.asString:
                return .AlignmentMask
            case JSONKey.DirectionLeadingToTrailing.asString:
                return .DirectionLeadingToTrailing
            case JSONKey.DirectionLeftToRight.asString:
                return .DirectionLeftToRight
            case JSONKey.DirectionRightToLeft.asString:
                return .DirectionRightToLeft
            case JSONKey.DirectionMask.asString:
                return .DirectionMask
            default:
                return .DirectionLeadingToTrailing
            }
            })
    }

    func encode() -> [String] {

        var options: [String] = []

        if self.contains(.AlignAllLeft) {
            options.append(JSONKey.AlignAllLeft.asString)
        } else if self.contains(.AlignAllRight) {
            options.append(JSONKey.AlignAllRight.asString)
        } else if self.contains(.AlignAllTop) {
            options.append(JSONKey.AlignAllTop.asString)
        } else if self.contains(.AlignAllBottom) {
            options.append(JSONKey.AlignAllBottom.asString)
        } else if self.contains(.AlignAllLeading) {
            options.append(JSONKey.AlignAllLeading.asString)
        } else if self.contains(.AlignAllTrailing) {
            options.append(JSONKey.AlignAllTrailing.asString)
        } else if self.contains(.AlignAllCenterX) {
            options.append(JSONKey.AlignAllCenterX.asString)
        } else if self.contains(.AlignAllCenterY) {
            options.append(JSONKey.AlignAllCenterY.asString)
        } else if self.contains(.AlignAllBaseline) {
            options.append(JSONKey.AlignAllBaseline.asString)
        } else if self.contains(.AlignAllLastBaseline) {
            options.append(JSONKey.AlignAllLastBaseline.asString)
        } else if self.contains(.AlignAllFirstBaseline) {
            options.append(JSONKey.AlignAllFirstBaseline.asString)
        } else if self.contains(.AlignmentMask) {
            options.append(JSONKey.AlignmentMask.asString)
        } else if self.contains(.DirectionLeadingToTrailing) {
            options.append(JSONKey.DirectionLeadingToTrailing.asString)
        } else if self.contains(.DirectionLeftToRight) {
            options.append(JSONKey.DirectionLeftToRight.asString)
        } else if self.contains(.DirectionRightToLeft) {
            options.append(JSONKey.DirectionRightToLeft.asString)
        } else if self.contains(.DirectionMask) {
            options.append(JSONKey.DirectionMask.asString)
        }
        
        return options
    }
}

extension UIScrollViewKeyboardDismissMode {
    private enum JSONKey: JSONKeyType {
        case None
        case OnDrag // dismisses the keyboard when a drag begins
        case Interactive // the keyboard follows the dragging touch off screen, and may be pulled upward again to cancel the dismiss
    }

    init(mode: String) {
        switch mode {
        case JSONKey.None.asString:
            self = .None
        case JSONKey.OnDrag.asString:
            self = .OnDrag
        case JSONKey.Interactive.asString:
            self = .Interactive
        default:
            self = .None
        }
    }

    var asString: String {
        switch self {
        case .None:
            return JSONKey.None.asString
        case .OnDrag:
            return JSONKey.OnDrag.asString
        case .Interactive:
            return JSONKey.Interactive.asString
        }
    }
}

extension UIScrollViewIndicatorStyle {
    private enum JSONKey: JSONKeyType {
        case Default // black with white border. good against any background
        case Black // black only. smaller. good against a white background
        case White // white only. smaller. good against a black background
    }

    init(style: String) {
        switch style {
        case JSONKey.Default.asString:
            self = .Default
        case JSONKey.Black.asString:
            self = .Black
        case JSONKey.White.asString:
            self = .White
        default:
            self = .Default
        }
    }

    var asString: String {
        switch self {
        case .Default:
            return JSONKey.Default.asString
        case .Black:
            return JSONKey.Black.asString
        case .White:
            return JSONKey.White.asString
        }
    }

}

extension UIControlState {
    private enum JSONKey: JSONKeyType {
        case Normal
        case Highlighted
        case Disabled
        case Selected
        case Focused
        case Application
        case Reserved
    }

    init(states: [String]) {
        self.init(states.flatMap { (state) -> UIControlState? in
            switch state {
            case JSONKey.Normal.asString:
                return .Normal
            case JSONKey.Highlighted.asString:
                return .Highlighted
            case JSONKey.Disabled.asString:
                return .Disabled
            case JSONKey.Selected.asString:
                return .Selected
            case JSONKey.Focused.asString:
                if #available(iOSApplicationExtension 9.0, *) {
                    return .Focused
                } else {
                    fallthrough
                }
            case JSONKey.Application.asString:
                return .Application
            case JSONKey.Reserved.asString:
                return .Reserved
            default:
                return .Normal
            }
            })
    }

    func encode() -> [String] {

        var states: [String] = []

        if self.contains(.Normal) {
            states.append(JSONKey.Normal.asString)
        } else if self.contains(.Highlighted) {
            states.append(JSONKey.Highlighted.asString)
        } else if self.contains(UIControlState.Disabled) {
            states.append(JSONKey.Disabled.asString)
        } else if self.contains(UIControlState.Selected) {
            states.append(JSONKey.Selected.asString)
        } else if self.contains(UIControlState.Application) {
            states.append(JSONKey.Application.asString)
        } else if self.contains(UIControlState.Reserved) {
            states.append(JSONKey.Reserved.asString)
        } else if #available(iOSApplicationExtension 9.0, *) {
            if self.contains(UIControlState.Focused) {
                states.append(JSONKey.Focused.asString)
            }
        }

        return states
    }
}

extension UITextFieldViewMode {
    private enum JSONKey: JSONKeyType {
        case Never
        case WhileEditing
        case UnlessEditing
        case Always
    }

    init(mode: String) {
        switch mode {
        case JSONKey.Never.asString:
            self = .Never
        case JSONKey.Always.asString:
            self = .Always
        case JSONKey.WhileEditing.asString:
            self = .WhileEditing
        case JSONKey.UnlessEditing.asString:
            self = .UnlessEditing
        default:
            self = .Never
        }
    }

    var asString: String {
        switch self {
        case .Never:
            return JSONKey.Never.asString
        case .Always:
            return JSONKey.Always.asString
        case .WhileEditing:
            return JSONKey.WhileEditing.asString
        case .UnlessEditing:
            return JSONKey.UnlessEditing.asString
        }
    }
}

extension UIDataDetectorTypes {
    private enum JSONKey: JSONKeyType {
        case PhoneNumber
        case Link
        case Address
        case CalendarEvent
        case None
        case All
    }

    init(types: [String]) {
        self.init(types.flatMap { (type) -> UIDataDetectorTypes? in
            switch type {
            case JSONKey.PhoneNumber.asString:
                return .PhoneNumber
            case JSONKey.Link.asString:
                return .Link
            case JSONKey.Address.asString:
                return .Address
            case JSONKey.CalendarEvent.asString:
                return .CalendarEvent
            case JSONKey.None.asString:
                return .None
            case JSONKey.All.asString:
                return .All
            default:
                return .None
            }
        })
    }

    func encode() -> [String] {
        
        var types: [String] = []

        if self.contains(UIDataDetectorTypes.PhoneNumber) {
            types.append(JSONKey.PhoneNumber.asString)
        } else if self.contains(UIDataDetectorTypes.Link) {
            types.append(JSONKey.Link.asString)
        } else if self.contains(UIDataDetectorTypes.Address) {
            types.append(JSONKey.Address.asString)
        } else if self.contains(UIDataDetectorTypes.CalendarEvent) {
            types.append(JSONKey.CalendarEvent.asString)
        } else if self.contains(UIDataDetectorTypes.None) {
            types.append(JSONKey.None.asString)
        } else if self.contains(UIDataDetectorTypes.All) {
            types.append(JSONKey.All.asString)
        }

        return types
    }
}

extension UIBaselineAdjustment {
    private enum JSONKey: JSONKeyType {
        case AlignBaselines // default. used when shrinking text to position based on the original baseline
        case AlignCenters
        case None
    }

    init(mode: String) {
        switch mode {
        case JSONKey.AlignBaselines.asString:
            self = .AlignBaselines
        case JSONKey.AlignCenters.asString:
            self = .AlignCenters
        case JSONKey.None.asString:
            self = .None
        default:
            self = .None
        }
    }

    var asString: String {
        switch self {
        case .AlignBaselines:
            return JSONKey.AlignBaselines.asString
        case .AlignCenters:
            return JSONKey.AlignCenters.asString
        case .None:
            return JSONKey.None.asString
        }
    }
}

extension UITextBorderStyle {
    private enum JSONKey: JSONKeyType {
        case None
        case Line
        case Bezel
        case RoundedRect
    }

    init(style: String) {
        switch style {
        case JSONKey.Bezel.asString:
            self = .Bezel
        case JSONKey.Line.asString:
            self = .Line
        case JSONKey.RoundedRect.asString:
            self = .RoundedRect
        case JSONKey.None.asString:
            self = .None
        default:
            self = .None
        }
    }

    var asString: String {
        switch self {
        case .Bezel:
            return JSONKey.Bezel.asString
        case .Line:
            return JSONKey.Line.asString
        case .RoundedRect:
            return JSONKey.RoundedRect.asString
        case .None:
            return JSONKey.None.asString
        }
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

extension CGSize {

    init(size: [CGFloat]) {
        guard size.count == 2 else {
            self.init(width: 0, height: 0)
            return
        }

        self.init(width: size[0], height: size[1])
    }

    public func encode() -> [CGFloat] {
        return [width, height]
    }
}

extension CGPoint {

    init(point: [CGFloat]) {
        guard point.count == 2 else {
            self.init(x: 0, y: 0)
            return
        }

        self.init(x: point[0], y: point[1])
    }

    public func encode() -> [CGFloat] {
        return [x, y]
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

extension NSURL {
    private enum JSONKey: JSONKeyType {
        case url
    }

    convenience init?(json: [String: AnyObject]) {
        do {
            let urlStr: String = try json.parse(JSONKey.url)
            self.init(string: urlStr)
        } catch {
            return nil
        }
    }

    public func encode() -> JSONDictionary {
        return [JSONKey.url.asString: self.absoluteString]
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

    public func encode() -> JSONDictionary {
        return [JSONKey.name.asString: self.fontName, JSONKey.size.asString: self.pointSize]
    }
}

extension UIColor {

    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let r, g, b, a: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 0)
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
            self.init(data: data, scale: UIScreen.mainScreen().scale)
        } else {
            return nil
        }
    }

    public func encode() -> JSONDictionary? {
        if let data = UIImagePNGRepresentation(self) {
            return [JSONKey.data.asString: data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)]
        }

        return nil
    }
}

func ==<T: Equatable, K1: Hashable, K2: Hashable>(lhs: [K1: [K2: T]], rhs: [K1: [K2: T]]) -> Bool {
    if lhs.count != rhs.count { return false }

    for (key, lhsub) in lhs {
        if let rhsub = rhs[key] {
            if lhsub != rhsub {
                return false
            }
        } else {
            return false
        }
    }

    return true
}

