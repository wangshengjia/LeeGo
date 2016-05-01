//
//  JSONConvertible.swift
//  LeeGo
//
//  Created by Victor WANG on 20/03/16.
//
//

import Foundation

protocol JSONConvertible {
    associatedtype Serializable

    /// Encode serializable target instance to JSON
    func encode() throws -> Serializable

    /// Decode json to serializable target instance
    init(rawValue: Serializable) throws
}

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

extension NSLayoutFormatOptions: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case AlignAllLeft, AlignAllRight, AlignAllTop, AlignAllBottom, AlignAllLeading, AlignAllTrailing, AlignAllCenterX, AlignAllCenterY, AlignAllBaseline, AlignAllLastBaseline, AlignAllFirstBaseline, AlignmentMask, DirectionLeadingToTrailing, DirectionLeftToRight, DirectionRightToLeft, DirectionMask
    }

    init(rawValue options: [String]) {
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

        if self.contains(.AlignAllLeft) { options.append(JSONKey.AlignAllLeft.asString) }
        if self.contains(.AlignAllRight) { options.append(JSONKey.AlignAllRight.asString) }
        if self.contains(.AlignAllTop) { options.append(JSONKey.AlignAllTop.asString) }
        if self.contains(.AlignAllBottom) { options.append(JSONKey.AlignAllBottom.asString) }
        if self.contains(.AlignAllLeading) { options.append(JSONKey.AlignAllLeading.asString) }
        if self.contains(.AlignAllTrailing) { options.append(JSONKey.AlignAllTrailing.asString) }
        if self.contains(.AlignAllCenterX) { options.append(JSONKey.AlignAllCenterX.asString) }
        if self.contains(.AlignAllCenterY) { options.append(JSONKey.AlignAllCenterY.asString) }
        if self.contains(.AlignAllBaseline) { options.append(JSONKey.AlignAllBaseline.asString) }
        if self.contains(.AlignAllLastBaseline) { options.append(JSONKey.AlignAllLastBaseline.asString) }
        if self.contains(.AlignAllFirstBaseline) { options.append(JSONKey.AlignAllFirstBaseline.asString) }
        if self.contains(.AlignmentMask) { options.append(JSONKey.AlignmentMask.asString) }

        if self.contains(.DirectionLeadingToTrailing) { options.append(JSONKey.DirectionLeadingToTrailing.asString) }
        if self.contains(.DirectionLeftToRight) { options.append(JSONKey.DirectionLeftToRight.asString) }
        if self.contains(.DirectionRightToLeft) { options.append(JSONKey.DirectionRightToLeft.asString) }
        if self.contains(.DirectionMask) { options.append(JSONKey.DirectionMask.asString) }
        
        return options
    }
}

extension UIScrollViewKeyboardDismissMode: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case None, OnDrag, Interactive
    }

    init(rawValue mode: String) {
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

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension UIScrollViewIndicatorStyle: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case Default, Black, White
    }

    init(rawValue style: String) {
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

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension UIControlState: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case Normal, Highlighted, Disabled, Selected, Focused, Application, Reserved
    }

    init(rawValue states: [String]) {
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
                if #available(iOS 9.0, *) {
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

        if self.contains(.Normal) { states.append(JSONKey.Normal.asString) }
        if self.contains(.Highlighted) { states.append(JSONKey.Highlighted.asString) }
        if self.contains(.Disabled) { states.append(JSONKey.Disabled.asString) }
        if self.contains(.Selected) { states.append(JSONKey.Selected.asString) }
        if self.contains(.Application) { states.append(JSONKey.Application.asString) }
        if self.contains(.Reserved) { states.append(JSONKey.Reserved.asString) }
        if #available(iOS 9.0, *) {
            if self.contains(.Focused) { states.append(JSONKey.Focused.asString) }
        }

        return states
    }
}

extension UITextFieldViewMode: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case Never, WhileEditing, UnlessEditing, Always
    }

    init(rawValue mode: String) {
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

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension UIDataDetectorTypes: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case PhoneNumber, Link, Address, CalendarEvent, None, All
    }

    init(rawValue types: [String]) {
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

        if self.contains(.PhoneNumber) { types.append(JSONKey.PhoneNumber.asString) }
        if self.contains(.Link) { types.append(JSONKey.Link.asString) }
        if self.contains(.Address) { types.append(JSONKey.Address.asString) }
        if self.contains(.CalendarEvent) { types.append(JSONKey.CalendarEvent.asString) }
        if self.contains(.None) { types.append(JSONKey.None.asString) }
        if self.contains(.All) { types.append(JSONKey.All.asString) }

        return types
    }
}

extension UIBaselineAdjustment: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case AlignBaselines, AlignCenters, None
    }

    init(rawValue mode: String) {
        switch mode {
        case JSONKey.AlignBaselines.asString:
            self = .AlignBaselines
        case JSONKey.AlignCenters.asString:
            self = .AlignCenters
        case JSONKey.None.asString:
            self = .None
        default:
            self = .AlignBaselines
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension UITextBorderStyle: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case None, Line, Bezel, RoundedRect
    }

    init(rawValue style: String) {
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

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension NSLineBreakMode: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case ByWordWrapping, ByCharWrapping, ByClipping, ByTruncatingHead, ByTruncatingTail, ByTruncatingMiddle
    }

    init(rawValue mode: String) {
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

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension NSTextAlignment: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case Left, Center, Right, Justified, Natural
    }

    init(rawValue align: String) {
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
            self = .Left
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension UIViewContentMode: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case ScaleToFill, ScaleAspectFit, ScaleAspectFill, Redraw, Center, Top, Bottom, Left, Right, TopLeft, TopRight, BottomLeft, BottomRight
    }

    init(rawValue mode: String) {
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

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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

extension UIViewTintAdjustmentMode: JSONConvertible {

    enum JSONKey: JSONKeyType {
        case Automatic, Normal, Dimmed
    }

    init(rawValue mode: String) {
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

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
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


extension NSRange: JSONConvertible {

    init(rawValue range: [Int]) {
        guard range.count == 2 else {
            self.init(location: 0, length: 0)
            return
        }

        self.init(location: range[0], length: range[1])
    }

    func encode() -> [Int] {
        return [location, length]
    }
}

extension CGSize: JSONConvertible {

    init(rawValue size: [CGFloat]) {
        guard size.count == 2 else {
            self.init(width: 0, height: 0)
            return
        }

        self.init(width: size[0], height: size[1])
    }

    func encode() -> [CGFloat] {
        return [width, height]
    }
}

extension CGPoint: JSONConvertible {

    init(rawValue point: [CGFloat]) {
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

extension UIEdgeInsets: JSONConvertible {

    init(rawValue insets: [CGFloat]) {
        guard insets.count == 4 else {
            self.init(top: 0, left: 0, bottom: 0, right: 0)
            return
        }

        self.init(top: insets[0], left: insets[1], bottom: insets[2], right: insets[3])
    }

    func encode() -> [CGFloat] {
        return [top, left, bottom, right]
    }
}

extension NSURL {
    private enum JSONKey: JSONKeyType {
        case url
    }

    convenience init?(rawValue json: JSONDictionary) {
        do {
            let urlStr: String = try json.parse(JSONKey.url)
            self.init(string: urlStr)
        } catch {
            return nil
        }
    }

    func lg_encode() -> JSONDictionary {
        return [JSONKey.url.asString: self.absoluteString]
    }
}

extension UIFont {

    private enum JSONKey: JSONKeyType {
        case name, size
    }

    convenience init?(json: JSONDictionary) {
        do {
            let fontName: String = try json.parse(JSONKey.name)
            let size: CGFloat = try json.parse(JSONKey.size)
            self.init(name: fontName, size: size)
        } catch {
            return nil
        }
    }

    func lg_encode() -> JSONDictionary {
        return [JSONKey.name.asString: self.fontName, JSONKey.size.asString: self.pointSize]
    }
}

extension UIColor {

    convenience init(rawValue hexString: String) {
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

    func lg_encode() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        if a == 1.0 {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }

        return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
}

extension UIImage {
    private enum JSONKey: JSONKeyType {
        case name, data
    }

    convenience init?(json: JSONDictionary?) {
        guard let json = json else { return nil }

        if let imageName: String = try? json.parse(JSONKey.name) {
            self.init(named: imageName)
        } else if let base64String: String = try? json.parse(JSONKey.data),
            let data = NSData(base64EncodedString: base64String, options: .IgnoreUnknownCharacters) {
            self.init(data: data, scale: UIScreen.mainScreen().scale)
        } else {
            return nil
        }
    }

    func lg_encode() -> JSONDictionary? {
        if let data = UIImagePNGRepresentation(self) {
            return [JSONKey.data.asString: data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)]
        }

        return nil
    }
}

