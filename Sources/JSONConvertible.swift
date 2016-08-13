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
        case alignAllLeft, alignAllRight, alignAllTop, alignAllBottom, alignAllLeading, alignAllTrailing, alignAllCenterX, alignAllCenterY, alignAllLastBaseline, alignAllFirstBaseline, alignmentMask, directionLeadingToTrailing, directionLeftToRight, directionRightToLeft, directionMask
    }

    init(rawValue options: [String]) {
        self.init(options.flatMap { (option) -> NSLayoutFormatOptions? in
            switch option {
            case JSONKey.alignAllLeft.asString:
                return .alignAllLeft
            case JSONKey.alignAllRight.asString:
                return .alignAllRight
            case JSONKey.alignAllTop.asString:
                return .alignAllTop
            case JSONKey.alignAllBottom.asString:
                return .alignAllBottom
            case JSONKey.alignAllLeading.asString:
                return .alignAllLeading
            case JSONKey.alignAllTrailing.asString:
                return .alignAllTrailing
            case JSONKey.alignAllCenterX.asString:
                return .alignAllCenterX
            case JSONKey.alignAllCenterY.asString:
                return .alignAllCenterY
            case JSONKey.alignAllLastBaseline.asString:
                return .alignAllLastBaseline
            case JSONKey.alignAllFirstBaseline.asString:
                return .alignAllFirstBaseline
            case JSONKey.alignmentMask.asString:
                return .alignmentMask
            case JSONKey.directionLeadingToTrailing.asString:
                return NSLayoutFormatOptions()
            case JSONKey.directionLeftToRight.asString:
                return .directionLeftToRight
            case JSONKey.directionRightToLeft.asString:
                return .directionRightToLeft
            case JSONKey.directionMask.asString:
                return .directionMask
            default:
                return NSLayoutFormatOptions()
            }
            })
    }

    func encode() -> [String] {

        var options: [String] = []

        if self.contains(.alignAllLeft) { options.append(JSONKey.alignAllLeft.asString) }
        if self.contains(.alignAllRight) { options.append(JSONKey.alignAllRight.asString) }
        if self.contains(.alignAllTop) { options.append(JSONKey.alignAllTop.asString) }
        if self.contains(.alignAllBottom) { options.append(JSONKey.alignAllBottom.asString) }
        if self.contains(.alignAllLeading) { options.append(JSONKey.alignAllLeading.asString) }
        if self.contains(.alignAllTrailing) { options.append(JSONKey.alignAllTrailing.asString) }
        if self.contains(.alignAllCenterX) { options.append(JSONKey.alignAllCenterX.asString) }
        if self.contains(.alignAllCenterY) { options.append(JSONKey.alignAllCenterY.asString) }
        if self.contains(.alignAllLastBaseline) { options.append(JSONKey.alignAllLastBaseline.asString) }
        if self.contains(.alignAllFirstBaseline) { options.append(JSONKey.alignAllFirstBaseline.asString) }
        if self.contains(.alignmentMask) { options.append(JSONKey.alignmentMask.asString) }

        if self.contains(NSLayoutFormatOptions()) { options.append(JSONKey.directionLeadingToTrailing.asString) }
        if self.contains(.directionLeftToRight) { options.append(JSONKey.directionLeftToRight.asString) }
        if self.contains(.directionRightToLeft) { options.append(JSONKey.directionRightToLeft.asString) }
        if self.contains(.directionMask) { options.append(JSONKey.directionMask.asString) }
        
        return options
    }
}

extension UIScrollViewKeyboardDismissMode: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case none, onDrag, interactive
    }

    init(rawValue mode: String) {
        switch mode {
        case JSONKey.none.asString:
            self = .none
        case JSONKey.onDrag.asString:
            self = .onDrag
        case JSONKey.interactive.asString:
            self = .interactive
        default:
            self = .none
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .none:
            return JSONKey.none.asString
        case .onDrag:
            return JSONKey.onDrag.asString
        case .interactive:
            return JSONKey.interactive.asString
        }
    }
}

extension UIScrollViewIndicatorStyle: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case `default`, black, white
    }

    init(rawValue style: String) {
        switch style {
        case JSONKey.default.asString:
            self = .default
        case JSONKey.black.asString:
            self = .black
        case JSONKey.white.asString:
            self = .white
        default:
            self = .default
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .default:
            return JSONKey.default.asString
        case .black:
            return JSONKey.black.asString
        case .white:
            return JSONKey.white.asString
        }
    }

}

extension UIControlState: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case normal, highlighted, disabled, selected, focused, application, reserved
    }

    init(rawValue states: [String]) {
        self.init(states.flatMap { (state) -> UIControlState? in
            switch state {
            case JSONKey.normal.asString:
                return UIControlState()
            case JSONKey.highlighted.asString:
                return .highlighted
            case JSONKey.disabled.asString:
                return .disabled
            case JSONKey.selected.asString:
                return .selected
            case JSONKey.focused.asString:
                if #available(iOS 9.0, *) {
                    return .focused
                } else {
                    fallthrough
                }
            case JSONKey.application.asString:
                return .application
            case JSONKey.reserved.asString:
                return .reserved
            default:
                return UIControlState()
            }
            })
    }

    func encode() -> [String] {

        var states: [String] = []

        if self.contains(UIControlState()) { states.append(JSONKey.normal.asString) }
        if self.contains(.highlighted) { states.append(JSONKey.highlighted.asString) }
        if self.contains(.disabled) { states.append(JSONKey.disabled.asString) }
        if self.contains(.selected) { states.append(JSONKey.selected.asString) }
        if self.contains(.application) { states.append(JSONKey.application.asString) }
        if self.contains(.reserved) { states.append(JSONKey.reserved.asString) }
        if #available(iOS 9.0, *) {
            if self.contains(.focused) { states.append(JSONKey.focused.asString) }
        }

        return states
    }
}

extension UITextFieldViewMode: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case never, whileEditing, unlessEditing, always
    }

    init(rawValue mode: String) {
        switch mode {
        case JSONKey.never.asString:
            self = .never
        case JSONKey.always.asString:
            self = .always
        case JSONKey.whileEditing.asString:
            self = .whileEditing
        case JSONKey.unlessEditing.asString:
            self = .unlessEditing
        default:
            self = .never
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .never:
            return JSONKey.never.asString
        case .always:
            return JSONKey.always.asString
        case .whileEditing:
            return JSONKey.whileEditing.asString
        case .unlessEditing:
            return JSONKey.unlessEditing.asString
        }
    }
}

extension UIDataDetectorTypes: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case phoneNumber, link, address, calendarEvent, none, all
    }

    init(rawValue types: [String]) {
        self.init(types.flatMap { (type) -> UIDataDetectorTypes? in
            switch type {
            case JSONKey.phoneNumber.asString:
                return .phoneNumber
            case JSONKey.link.asString:
                return .link
            case JSONKey.address.asString:
                return .address
            case JSONKey.calendarEvent.asString:
                return .calendarEvent
            case JSONKey.none.asString:
                return .none
            case JSONKey.all.asString:
                return .all
            default:
                return .none
            }
        })
    }

    func encode() -> [String] {
        
        var types: [String] = []

        if self.contains(.phoneNumber) { types.append(JSONKey.phoneNumber.asString) }
        if self.contains(.link) { types.append(JSONKey.link.asString) }
        if self.contains(.address) { types.append(JSONKey.address.asString) }
        if self.contains(.calendarEvent) { types.append(JSONKey.calendarEvent.asString) }
        if self.contains(UIDataDetectorTypes()) { types.append(JSONKey.none.asString) }
        if self.contains(.all) { types.append(JSONKey.all.asString) }

        return types
    }
}

extension UIBaselineAdjustment: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case alignBaselines, alignCenters, none
    }

    init(rawValue mode: String) {
        switch mode {
        case JSONKey.alignBaselines.asString:
            self = .alignBaselines
        case JSONKey.alignCenters.asString:
            self = .alignCenters
        case JSONKey.none.asString:
            self = .none
        default:
            self = .alignBaselines
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .alignBaselines:
            return JSONKey.alignBaselines.asString
        case .alignCenters:
            return JSONKey.alignCenters.asString
        case .none:
            return JSONKey.none.asString
        }
    }
}

extension UITextBorderStyle: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case none, line, bezel, roundedRect
    }

    init(rawValue style: String) {
        switch style {
        case JSONKey.bezel.asString:
            self = .bezel
        case JSONKey.line.asString:
            self = .line
        case JSONKey.roundedRect.asString:
            self = .roundedRect
        case JSONKey.none.asString:
            self = .none
        default:
            self = .none
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .bezel:
            return JSONKey.bezel.asString
        case .line:
            return JSONKey.line.asString
        case .roundedRect:
            return JSONKey.roundedRect.asString
        case .none:
            return JSONKey.none.asString
        }
    }
}

extension NSLineBreakMode: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case byWordWrapping, byCharWrapping, byClipping, byTruncatingHead, byTruncatingTail, byTruncatingMiddle
    }

    init(rawValue mode: String) {
        switch mode {
        case JSONKey.byWordWrapping.asString:
            self = .byWordWrapping
        case JSONKey.byCharWrapping.asString:
            self = .byCharWrapping
        case JSONKey.byClipping.asString:
            self = .byClipping
        case JSONKey.byTruncatingHead.asString:
            self = .byTruncatingHead
        case JSONKey.byTruncatingTail.asString:
            self = .byTruncatingTail
        case JSONKey.byTruncatingMiddle.asString:
            self = .byTruncatingMiddle
        default:
            self = .byWordWrapping
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .byWordWrapping:
            return JSONKey.byWordWrapping.asString
        case .byCharWrapping:
            return JSONKey.byCharWrapping.asString
        case .byClipping:
            return JSONKey.byClipping.asString
        case .byTruncatingHead:
            return JSONKey.byTruncatingHead.asString
        case .byTruncatingTail:
            return JSONKey.byTruncatingTail.asString
        case .byTruncatingMiddle:
            return JSONKey.byTruncatingMiddle.asString
        }
    }

}

extension NSTextAlignment: JSONConvertible {
    private enum JSONKey: JSONKeyType {
        case left, center, right, justified, natural
    }

    init(rawValue align: String) {
        switch align {
        case JSONKey.left.asString:
            self = .left
        case JSONKey.center.asString:
            self = .center
        case JSONKey.justified.asString:
            self = .justified
        case JSONKey.right.asString:
            self = .right
        case JSONKey.natural.asString:
            self = .natural
        default:
            self = .left
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .left:
            return JSONKey.left.asString
        case .center:
            return JSONKey.center.asString
        case .justified:
            return JSONKey.justified.asString
        case .right:
            return JSONKey.right.asString
        case .natural:
            return JSONKey.natural.asString
        }
    }
}

extension UIViewContentMode: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case scaleToFill, scaleAspectFit, scaleAspectFill, redraw, center, top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight
    }

    init(rawValue mode: String) {
        switch mode {
        case JSONKey.bottom.asString:
            self = .bottom
        case JSONKey.bottomLeft.asString:
            self = .bottomLeft
        case JSONKey.bottomRight.asString:
            self = .bottomRight
        case JSONKey.center.asString:
            self = .center
        case JSONKey.left.asString:
            self = .left
        case JSONKey.redraw.asString:
            self = .redraw
        case JSONKey.right.asString:
            self = .right
        case JSONKey.scaleAspectFill.asString:
            self = .scaleAspectFill
        case JSONKey.scaleAspectFit.asString:
            self = .scaleAspectFit
        case JSONKey.scaleToFill.asString:
            self = .scaleToFill
        case JSONKey.top.asString:
            self = .top
        case JSONKey.topLeft.asString:
            self = .topLeft
        case JSONKey.topRight.asString:
            self = .topRight
        default:
            self = .scaleToFill
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .bottom:
            return JSONKey.bottom.asString
        case .bottomLeft:
            return JSONKey.bottomLeft.asString
        case .bottomRight:
            return JSONKey.bottomRight.asString
        case .center:
            return JSONKey.center.asString
        case .left:
            return JSONKey.left.asString
        case .redraw:
            return JSONKey.redraw.asString
        case .right:
            return JSONKey.right.asString
        case .scaleAspectFill:
            return JSONKey.scaleAspectFill.asString
        case .scaleAspectFit:
            return JSONKey.scaleAspectFit.asString
        case .scaleToFill:
            return JSONKey.scaleToFill.asString
        case .top:
            return JSONKey.top.asString
        case .topLeft:
            return JSONKey.topLeft.asString
        case .topRight:
            return JSONKey.topRight.asString
        }
    }

}

extension UIViewTintAdjustmentMode: JSONConvertible {

    enum JSONKey: JSONKeyType {
        case automatic, normal, dimmed
    }

    init(rawValue mode: String) {
        switch mode {
        case JSONKey.automatic.asString:
            self = .automatic
        case JSONKey.normal.asString:
            self = .normal
        case JSONKey.dimmed.asString:
            self = .dimmed
        default:
            self = .automatic
        }
    }

    func encode() -> String {
        return self.asString
    }

    private var asString: String {
        switch self {
        case .automatic:
            return JSONKey.automatic.asString
        case .normal:
            return JSONKey.normal.asString
        case .dimmed:
            return JSONKey.dimmed.asString
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

extension URL {
    private enum JSONKey: JSONKeyType {
        case url
    }

    init?(rawValue json: JSONDictionary) {
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
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
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
            let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            self.init(data: data, scale: UIScreen.main.scale)
        } else {
            return nil
        }
    }

    func lg_encode() -> JSONDictionary? {
        if let data = UIImagePNGRepresentation(self) {
            return [JSONKey.data.asString: data.base64EncodedString(options: .lineLength64Characters)]
        }

        return nil
    }
}

