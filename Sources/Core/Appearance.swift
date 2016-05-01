//
//  Appearance.swift
//  LeeGo
//
//  Created by Victor WANG on 13/03/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation

public typealias Attributes = [String: AnyObject]

/// Represent an appearance property of a UIView or it's subclass.
/// For all supported Appearance: 
/// 
/// [Please find the reference here](google.com)
public enum Appearance {
    // UIView
    case userInteractionEnabled(Bool), translatesAutoresizingMaskIntoConstraints(Bool), backgroundColor(UIColor), tintColor(UIColor), tintAdjustmentMode(UIViewTintAdjustmentMode), cornerRadius(CGFloat), borderWidth(CGFloat), borderColor(UIColor), multipleTouchEnabled(Bool), exclusiveTouch(Bool), clipsToBounds(Bool), alpha(CGFloat), opaque(Bool), clearsContextBeforeDrawing(Bool), hidden(Bool), contentMode(UIViewContentMode)

    // UIControl
    case enabled(Bool), selected(Bool), highlighted(Bool)

    // UILabel & UITextView & UITextField
    case font(UIFont), textColor(UIColor), textAlignment(NSTextAlignment), numberOfLines(Int), lineBreakMode(NSLineBreakMode), selectedRange(NSRange), editable(Bool), selectable(Bool), dataDetectorTypes(UIDataDetectorTypes), allowsEditingTextAttributes(Bool), clearsOnInsertion(Bool), textContainerInset(UIEdgeInsets), linkTextAttributes(Attributes), lineFragmentPadding(CGFloat), minimumScaleFactor(CGFloat), adjustsFontSizeToFitWidth(Bool), baselineAdjustment(UIBaselineAdjustment), shadowColor(UIColor), shadowOffset(CGSize), highlightedTextColor(UIColor)

    case attributedText([Attributes]) // TODO: handle also NSParagrapheStyle

    case text(String), borderStyle(UITextBorderStyle), defaultTextAttributes(Attributes), placeholder(String), clearsOnBeginEditing(Bool), background(UIImage), disabledBackground(UIImage), typingAttributes(Attributes), clearButtonMode(UITextFieldViewMode)

    // UIButton
    case buttonType(UIButtonType), buttonTitle(String, UIControlState), buttonTitleColor(UIColor, UIControlState), buttonTitleShadowColor(UIColor, UIControlState), buttonImage(UIImage, UIControlState), buttonBackgroundImage(UIImage, UIControlState), buttonAttributedTitle([Attributes], UIControlState), contentEdgeInsets(UIEdgeInsets), titleEdgeInsets(UIEdgeInsets), reversesTitleShadowWhenHighlighted(Bool), imageEdgeInsets(UIEdgeInsets), adjustsImageWhenHighlighted(Bool), adjustsImageWhenDisabled(Bool), showsTouchWhenHighlighted(Bool)

    // UIImageView
    case ratio(CGFloat)

    // UIScrollView
    case scrollEnabled(Bool), contentOffset(CGPoint), contentSize(CGSize), contentInset(UIEdgeInsets), directionalLockEnabled(Bool), bounces(Bool), alwaysBounceVertical(Bool), alwaysBounceHorizontal(Bool), pagingEnabled(Bool), showsHorizontalScrollIndicator(Bool), showsVerticalScrollIndicator(Bool), scrollIndicatorInsets(UIEdgeInsets), indicatorStyle(UIScrollViewIndicatorStyle), decelerationRate(CGFloat), delaysContentTouches(Bool), canCancelContentTouches(Bool), minimumZoomScale(CGFloat), maximumZoomScale(CGFloat), zoomScale(CGFloat), bouncesZoom(Bool), scrollsToTop(Bool), keyboardDismissMode(UIScrollViewKeyboardDismissMode)

    // ...

    // Custom
    case custom([String: AnyObject])
    case none
}

extension Appearance: Hashable {
    /// Same name, same hash value
    public var hashValue: Int {
        return asString().hashValue
    }
}

///  Equatable
///
///  - parameter lhs: an `Appearance` instance
///  - parameter rhs: anther `Appearance` instance
///
///  - returns: true if they have same name, even they have different associated value.
///
///  Ex:
///  ``` 
///  textColor(UIColor.whiteColor()) == textColor(UIColor.blackColor()) 
///  ```
public func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    return lhs.asString() == rhs.asString()
}

extension Appearance {
    internal func apply<View: UIView>(to targetView: View, useDefaultValue: Bool = false) {

        switch (self, targetView) {

        // UIView
        case (let .backgroundColor(color), _):
            targetView.backgroundColor = !useDefaultValue ? color : nil
        case (let .userInteractionEnabled(userInteractionEnabled), _):
            targetView.userInteractionEnabled = !useDefaultValue ? userInteractionEnabled : !((targetView is UILabel) || (targetView is UIImageView))
        case (let .translatesAutoresizingMaskIntoConstraints(should), _):
            targetView.translatesAutoresizingMaskIntoConstraints = !useDefaultValue ? should : false
        case (let .tintColor(color), _):
            targetView.tintColor = !useDefaultValue ? color : nil
        case (let .tintAdjustmentMode(mode), _):
            targetView.tintAdjustmentMode = !useDefaultValue ? mode : .Automatic
        case (let .cornerRadius(radius), _):
            targetView.layer.cornerRadius = !useDefaultValue ? radius : 0
        case (let .borderWidth(borderWidth), _):
            targetView.layer.borderWidth = !useDefaultValue ? borderWidth : 0
        case (let .borderColor(borderColor), _):
            targetView.layer.borderColor = !useDefaultValue ? borderColor.CGColor : nil
        case (let .multipleTouchEnabled(multipleTouchEnabled), _):
            targetView.multipleTouchEnabled = !useDefaultValue ? multipleTouchEnabled : false
        case (let .exclusiveTouch(exclusiveTouch), _):
            targetView.exclusiveTouch = !useDefaultValue ? exclusiveTouch : false
        case (let .clipsToBounds(clipsToBounds), _):
            targetView.clipsToBounds = !useDefaultValue ? clipsToBounds : false
        case (let .alpha(alpha), _):
            targetView.alpha = !useDefaultValue ? alpha : 1.0
        case (let .opaque(opaque), _):
            targetView.opaque = !useDefaultValue ? opaque : true
        case (let .hidden(hidden), _):
            targetView.hidden = !useDefaultValue ? hidden : false
        case (let .clearsContextBeforeDrawing(clearsContextBeforeDrawing), _):
            targetView.clearsContextBeforeDrawing = !useDefaultValue ? clearsContextBeforeDrawing : true
        case (let .contentMode(contentMode), _):
            targetView.contentMode = !useDefaultValue ? contentMode : .ScaleToFill

        // UIControl
        case (let .selected(selected), let control as UIControl):
            control.selected = !useDefaultValue ? selected : false

        // UILabel
        case (let .shadowColor(color), let label as UILabel):
            label.shadowColor = !useDefaultValue ? color : nil
        case (let .shadowOffset(size), let label as UILabel):
            label.shadowOffset = !useDefaultValue ? size : CGSize(width: 0, height: -1)
        case (let .highlightedTextColor(color), let label as UILabel):
            label.highlightedTextColor = !useDefaultValue ? color : nil
        case (let .minimumScaleFactor(factor), let label as UILabel):
            label.minimumScaleFactor = !useDefaultValue ? factor : 0.0
        case (let .baselineAdjustment(adjustment), let label as UILabel):
            label.baselineAdjustment = !useDefaultValue ? adjustment : .AlignBaselines

        // UILabel & UITextField & UITextView
        case (let .enabled(enabled), let view):
            if let label = view as? UILabel {
                label.enabled = !useDefaultValue ? enabled : true
            } else if let control = view as? UIControl {
                control.enabled = !useDefaultValue ? enabled : true
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .highlighted(highlighted), let view):
            if let label = view as? UILabel {
                label.highlighted = !useDefaultValue ? highlighted : false
            } else if let control = view as? UIControl {
                control.highlighted = !useDefaultValue ? highlighted : false
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .adjustsFontSizeToFitWidth(should), let view):
            if let label = view as? UILabel {
                label.adjustsFontSizeToFitWidth = !useDefaultValue ? should : false
            } else if let textField = view as? UITextField {
                textField.adjustsFontSizeToFitWidth = !useDefaultValue ? should : false
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .font(font), let view):
            if let label = view as? UILabel {
                label.font = !useDefaultValue ? font : nil
            } else if let textField = view as? UITextField {
                textField.font = !useDefaultValue ? font : nil
            } else if let textView = view as? UITextView {
                textView.font = !useDefaultValue ? font : nil
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .textColor(color), let view):
            if let label = view as? UILabel {
                label.textColor = !useDefaultValue ? color : nil
            } else if let textField = view as? UITextField {
                textField.textColor = !useDefaultValue ? color : nil
            } else if let textView = view as? UITextView {
                textView.textColor = !useDefaultValue ? color : nil
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .textAlignment(align), let view):
            if let label = view as? UILabel {
                label.textAlignment = !useDefaultValue ? align : .Left
            } else if let textField = view as? UITextField {
                textField.textAlignment = !useDefaultValue ? align : .Left
            } else if let textView = view as? UITextView {
                textView.textAlignment = !useDefaultValue ? align : .Left
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .numberOfLines(number), let view):
            if let label = view as? UILabel {
                label.numberOfLines = !useDefaultValue ? number : 1
            } else if let textView = view as? UITextView {
                textView.textContainer.maximumNumberOfLines = !useDefaultValue ? number : 0
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .text(text), let view):
            if let label = view as? UILabel {
                label.text = !useDefaultValue ? text : nil
            } else if let textField = view as? UITextField {
                textField.text = !useDefaultValue ? text : nil
            } else if let textView = view as? UITextView {
                textView.text = !useDefaultValue ? text : nil
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .attributedText(attributes), let view):
            if let label = view as? UILabel {
                label.lg_setAttributedString(with: !useDefaultValue ? attributes : [])
            } else if let textField = view as? UITextField {
                textField.lg_setAttributedString(with: !useDefaultValue ? attributes : [])
            } else if let textView = view as? UITextView {
                textView.lg_setAttributedString(with: !useDefaultValue ? attributes : [])
            } else {
                warningUnknownAppearance(targetView)
            }
        case (let .lineBreakMode(mode), let view):
            if let label = view as? UILabel {
                label.lineBreakMode = !useDefaultValue ? mode : .ByWordWrapping
            } else if let textView = view as? UITextView {
                textView.textContainer.lineBreakMode = !useDefaultValue ? mode : .ByWordWrapping
            } else {
                warningUnknownAppearance(targetView)
            }

        case (let .allowsEditingTextAttributes(allows), let view):
            if let textField = view as? UITextField {
                textField.allowsEditingTextAttributes = !useDefaultValue ? allows : false
            } else if let textView = view as? UITextView {
                textView.allowsEditingTextAttributes = !useDefaultValue ? allows : false
            } else {
                warningUnknownAppearance(targetView)
            }

        case (let .clearsOnInsertion(clearsOnInsertion), let view):
            if let textField = view as? UITextField {
                textField.clearsOnInsertion = !useDefaultValue ? clearsOnInsertion : false
            } else if let textView = view as? UITextView {
                textView.clearsOnInsertion = !useDefaultValue ? clearsOnInsertion : false
            } else {
                warningUnknownAppearance(targetView)
            }

        // UITextView
        case (let .selectedRange(range), let textView as UITextView):
            textView.selectedRange = !useDefaultValue ? range : NSRange(location: 0, length: 0)
        case (let .editable(editable), let textView as UITextView):
            textView.editable = !useDefaultValue ? editable : false
        case (let .selectable(selectable), let textView as UITextView):
            textView.selectable = !useDefaultValue ? selectable : true
        case (let .dataDetectorTypes(types), let textView as UITextView):
            textView.dataDetectorTypes = !useDefaultValue ? types : .None
        case (let .textContainerInset(inset), let textView as UITextView):
            textView.textContainerInset = !useDefaultValue ? inset : UIEdgeInsetsZero
        case (let .linkTextAttributes(attrs), let textView as UITextView):
            textView.linkTextAttributes = !useDefaultValue ? attrs : nil
        case (let .lineFragmentPadding(padding), let textView as UITextView):
            textView.textContainer.lineFragmentPadding = !useDefaultValue ? padding : 5

        // UITextField
        case (let .borderStyle(style), let textField as UITextField):
            textField.borderStyle = !useDefaultValue ? style : .None
        case (let .defaultTextAttributes(attributes), let textField as UITextField):
            textField.defaultTextAttributes = !useDefaultValue ? attributes : [:]
        case (let .placeholder(text), let textField as UITextField):
            textField.placeholder = !useDefaultValue ? text : nil
        case (let .clearsOnBeginEditing(should), let textField as UITextField):
            textField.clearsOnBeginEditing = !useDefaultValue ? should : false
        case (let .background(image), let textField as UITextField):
            textField.background = !useDefaultValue ? image : nil
        case (let .disabledBackground(image), let textField as UITextField):
            textField.disabledBackground = !useDefaultValue ? image : nil
        case (let .typingAttributes(attributes), let textField as UITextField):
            textField.typingAttributes = !useDefaultValue ? attributes : nil
        case (let .clearButtonMode(mode), let textField as UITextField):
            textField.clearButtonMode = !useDefaultValue ? mode : .Never

        // UIButton
        case (let .buttonType(type), _ as UIButton):
            print("For the moment, LeeGo only support default button type. Can't handle \(type)")
            break
        case (let .buttonTitle(title, state), let button as UIButton):
            button.setTitle(!useDefaultValue ? title : nil, forState: state)
        case (let .buttonTitleColor(color, state), let button as UIButton):
            button.setTitleColor(!useDefaultValue ? color : nil, forState: state)
        case (let .buttonTitleShadowColor(color, state), let button as UIButton):
            button.setTitleShadowColor(!useDefaultValue ? color : nil, forState: state)
        case (let .buttonImage(image, state), let button as UIButton):
            button.setImage(!useDefaultValue ? image : nil, forState: state)
        case (let .buttonBackgroundImage(image, state), let button as UIButton):
            button.setBackgroundImage(!useDefaultValue ? image : nil, forState: state)
        case (let .buttonAttributedTitle(attributes, state), let button as UIButton):
            button.lg_setAttributedButtonTitle(with: !useDefaultValue ? attributes : [], state: state)
        case (let .contentEdgeInsets(insets), let button as UIButton):
            button.contentEdgeInsets = !useDefaultValue ? insets : UIEdgeInsetsZero
        case (let .titleEdgeInsets(insets), let button as UIButton):
            button.titleEdgeInsets = !useDefaultValue ? insets : UIEdgeInsetsZero
        case (let .imageEdgeInsets(insets), let button as UIButton):
            button.imageEdgeInsets = !useDefaultValue ? insets : UIEdgeInsetsZero
        case (let .reversesTitleShadowWhenHighlighted(should), let button as UIButton):
            button.reversesTitleShadowWhenHighlighted = !useDefaultValue ? should : false
        case (let .adjustsImageWhenHighlighted(should), let button as UIButton):
            button.adjustsImageWhenHighlighted = !useDefaultValue ? should : true
        case (let .adjustsImageWhenDisabled(should), let button as UIButton):
            button.adjustsImageWhenDisabled = !useDefaultValue ? should : true
        case (let .showsTouchWhenHighlighted(should), let button as UIButton):
            button.showsTouchWhenHighlighted = !useDefaultValue ? should : false

        // UIImageView
        case (let .ratio(ratioValue), let image as UIImageView):

            image.removeConstraints(image.constraints.filter({ (constraint) -> Bool in
                if constraint.mode == .Ratio {
                    return true
                }
                return false
            }))

            if !useDefaultValue {
                let constraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: image, attribute: NSLayoutAttribute.Height, multiplier: ratioValue, constant: 0)
                constraint.lg_setIdentifier(with: .Ratio)
                constraint.priority = 990
                image.addConstraint(constraint)
            }

        // UIScrollView
        case (let .scrollEnabled(scrollEnabled), let scrollView as UIScrollView):
            scrollView.scrollEnabled = !useDefaultValue ? scrollEnabled : true
        case (let .contentOffset(offset), let scrollView as UIScrollView):
            scrollView.contentOffset = !useDefaultValue ? offset : CGPointZero
        case (let .contentSize(size), let scrollView as UIScrollView):
            scrollView.contentSize = !useDefaultValue ? size : CGSizeZero
        case (let .contentInset(inset), let scrollView as UIScrollView):
            scrollView.contentInset = !useDefaultValue ? inset : UIEdgeInsetsZero
        case (let .directionalLockEnabled(enabled), let scrollView as UIScrollView):
            scrollView.directionalLockEnabled = !useDefaultValue ? enabled : false
        case (let .bounces(bounces), let scrollView as UIScrollView):
            scrollView.bounces = !useDefaultValue ? bounces : true
        case (let .alwaysBounceVertical(alwaysBounceVertical), let scrollView as UIScrollView):
            scrollView.alwaysBounceVertical = !useDefaultValue ? alwaysBounceVertical : false
        case (let .alwaysBounceHorizontal(alwaysBounceHorizontal), let scrollView as UIScrollView):
            scrollView.alwaysBounceHorizontal = !useDefaultValue ? alwaysBounceHorizontal : false
        case (let .pagingEnabled(pagingEnabled), let scrollView as UIScrollView):
            scrollView.pagingEnabled = !useDefaultValue ? pagingEnabled : false
        case (let .showsHorizontalScrollIndicator(show), let scrollView as UIScrollView):
            scrollView.showsHorizontalScrollIndicator = !useDefaultValue ? show : true
        case (let .showsVerticalScrollIndicator(show), let scrollView as UIScrollView):
            scrollView.showsVerticalScrollIndicator = !useDefaultValue ? show : true
        case (let .scrollIndicatorInsets(insets), let scrollView as UIScrollView):
            scrollView.scrollIndicatorInsets = !useDefaultValue ? insets : UIEdgeInsetsZero
        case (let .indicatorStyle(style), let scrollView as UIScrollView):
            scrollView.indicatorStyle = !useDefaultValue ? style : .Default
        case (let .decelerationRate(rate), let scrollView as UIScrollView):
            scrollView.decelerationRate = !useDefaultValue ? rate : UIScrollViewDecelerationRateNormal
        case (let .delaysContentTouches(delaysContentTouches), let scrollView as UIScrollView):
            scrollView.delaysContentTouches = !useDefaultValue ? delaysContentTouches : true
        case (let .canCancelContentTouches(canCancelContentTouches), let scrollView as UIScrollView):
            scrollView.canCancelContentTouches = !useDefaultValue ? canCancelContentTouches : true
        case (let .minimumZoomScale(minimumZoomScale), let scrollView as UIScrollView):
            scrollView.minimumZoomScale = !useDefaultValue ? minimumZoomScale : 1.0
        case (let .maximumZoomScale(maximumZoomScale), let scrollView as UIScrollView):
            scrollView.maximumZoomScale = !useDefaultValue ? maximumZoomScale : 1.0
        case (let .zoomScale(zoomScale), let scrollView as UIScrollView):
            scrollView.zoomScale = !useDefaultValue ? zoomScale : 1.0
        case (let .bouncesZoom(bouncesZoom), let scrollView as UIScrollView):
            scrollView.bouncesZoom = !useDefaultValue ? bouncesZoom : true
        case (let .scrollsToTop(scrollsToTop), let scrollView as UIScrollView):
            scrollView.scrollsToTop = !useDefaultValue ? scrollsToTop : true
        case (let .keyboardDismissMode(keyboardDismissMode), let scrollView as UIScrollView):
            scrollView.keyboardDismissMode = !useDefaultValue ? keyboardDismissMode :.None

        // Custom
        case (let .custom(dictionary), _):
            !useDefaultValue ? targetView.lg_setupCustomStyle(dictionary) : targetView.lg_removeCustomStyle(dictionary)

        default:
            warningUnknownAppearance(targetView)
            break
        }
    }

    private func warningUnknownAppearance<View: UIView>(targetView: View) {
        assertionFailure("Unknown appearance \(self) for view \(targetView)")
    }

    private func asString() -> String {
        let strSelf = String(self)
        if let index = strSelf.characters.indexOf("(") {
            return String(self).substringToIndex(index)
        }
        return strSelf
    }
}

extension Appearance: JSONConvertible {

    private enum JSONKey: JSONKeyType {
        case userInteractionEnabled, translatesAutoresizingMaskIntoConstraints, backgroundColor, tintColor, tintAdjustmentMode, cornerRadius, borderWidth, borderColor, multipleTouchEnabled, exclusiveTouch, clipsToBounds, alpha, opaque, clearsContextBeforeDrawing, hidden, contentMode

        // UIControl
        case enabled, selected, highlighted

        // UILabel & UITextView & UITextField
        case font, textColor, textAlignment, numberOfLines, lineBreakMode, selectedRange, editable, selectable, dataDetectorTypes, allowsEditingTextAttributes, clearsOnInsertion, textContainerInset, linkTextAttributes, lineFragmentPadding, minimumScaleFactor, adjustsFontSizeToFitWidth, baselineAdjustment, shadowColor, shadowOffset, highlightedTextColor

        case attributedText

        case text, borderStyle, defaultTextAttributes, placeholder, clearsOnBeginEditing, background, disabledBackground, typingAttributes, clearButtonMode

        // UIButton
        case buttonType, buttonTitle, buttonTitleColor, buttonTitleShadowColor, buttonImage, buttonBackgroundImage, buttonAttributedTitle, contentEdgeInsets, titleEdgeInsets, reversesTitleShadowWhenHighlighted, imageEdgeInsets, adjustsImageWhenHighlighted, adjustsImageWhenDisabled, showsTouchWhenHighlighted

        // UIImageView
        case ratio

        // UIScrollView
        case scrollEnabled, contentOffset, contentSize, contentInset, directionalLockEnabled, bounces, alwaysBounceVertical, alwaysBounceHorizontal, pagingEnabled, showsHorizontalScrollIndicator, showsVerticalScrollIndicator, scrollIndicatorInsets, indicatorStyle, decelerationRate, delaysContentTouches, canCancelContentTouches, minimumZoomScale, maximumZoomScale, zoomScale, bouncesZoom, scrollsToTop, keyboardDismissMode
    }

    internal static func JSONWithAppearances(appearances: [Appearance]) -> JSONDictionary {
        return appearances.flatMap({
            (appearance) -> JSONDictionary? in
            return appearance.encode()
        }).reduce([:], combine: {
            (result, json) -> JSONDictionary in
            return result + json
        })
    }

    internal static func appearancesWithJSON(json: JSONDictionary) -> [Appearance] {
        return json.map({
            (key, value) -> JSONDictionary in
            return [key: value]
        }).map({
            json -> Appearance in
            return Appearance(rawValue: json)
        })
    }

    internal init(rawValue json: JSONDictionary?) {

        self = .none

        guard let tuple = json?.first else {
            return
        }

        switch tuple {
        case let (JSONKey.userInteractionEnabled.asString, value as Bool):
            self = .userInteractionEnabled(value)
        case let (JSONKey.translatesAutoresizingMaskIntoConstraints.asString, value as Bool):
            self = .translatesAutoresizingMaskIntoConstraints(value)
        case let (JSONKey.backgroundColor.asString, value as String):
            self = .backgroundColor(UIColor(rawValue: value))
        case let (JSONKey.tintColor.asString, value as String):
            self = .tintColor(UIColor(rawValue: value))
        case let (JSONKey.tintAdjustmentMode.asString, value as String):
            self = .tintAdjustmentMode(UIViewTintAdjustmentMode(rawValue: value))
        case let (JSONKey.cornerRadius.asString, value as CGFloat):
            self = .cornerRadius(value)
        case let (JSONKey.borderWidth.asString, value as CGFloat):
            self = .borderWidth(value)
        case let (JSONKey.borderColor.asString, value as String):
            self = .borderColor(UIColor(rawValue: value))
        case let (JSONKey.multipleTouchEnabled.asString, value as Bool):
            self = .multipleTouchEnabled(value)
        case let (JSONKey.exclusiveTouch.asString, value as Bool):
            self = .exclusiveTouch(value)
        case let (JSONKey.clipsToBounds.asString, value as Bool):
            self = .clipsToBounds(value)
        case let (JSONKey.alpha.asString, value as CGFloat):
            self = .alpha(value)
        case let (JSONKey.opaque.asString, value as Bool):
            self = .opaque(value)
        case let (JSONKey.clearsContextBeforeDrawing.asString, value as Bool):
            self = .clearsContextBeforeDrawing(value)
        case let (JSONKey.hidden.asString, value as Bool):
            self = .hidden(value)
        case let (JSONKey.contentMode.asString, value as String):
            self = .contentMode(UIViewContentMode(rawValue: value))

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
            self = .textColor(UIColor(rawValue: value))
        case let (JSONKey.textAlignment.asString, value as String):
            self = .textAlignment(NSTextAlignment(rawValue: value))
        case let (JSONKey.numberOfLines.asString, value as Int):
            self = .numberOfLines(value)
        case let (JSONKey.lineBreakMode.asString, value as String):
            self = .lineBreakMode(NSLineBreakMode(rawValue: value))
        case let (JSONKey.selectedRange.asString, value as [Int]):
            self = .selectedRange(NSRange(rawValue: value))
        case let (JSONKey.editable.asString, value as Bool):
            self = .editable(value)
        case let (JSONKey.selectable.asString, value as Bool):
            self = .selectable(value)
        case let (JSONKey.dataDetectorTypes.asString, value as [String]):
            self = .dataDetectorTypes(UIDataDetectorTypes(rawValue: value))
        case let (JSONKey.allowsEditingTextAttributes.asString, value as Bool):
            self = .allowsEditingTextAttributes(value)
        case let (JSONKey.clearsOnInsertion.asString, value as Bool):
            self = .clearsOnInsertion(value)
        case let (JSONKey.textContainerInset.asString, value as [CGFloat]):
            self = .textContainerInset(UIEdgeInsets(rawValue: value))
        case let (JSONKey.linkTextAttributes.asString, value as Attributes):
            self = .linkTextAttributes(Appearance.decodeAttributes(value))
        case let (JSONKey.lineFragmentPadding.asString, value as CGFloat):
            self = .lineFragmentPadding(value)
        case let (JSONKey.minimumScaleFactor.asString, value as CGFloat):
            self = .minimumScaleFactor(value)
        case let (JSONKey.adjustsFontSizeToFitWidth.asString, value as Bool):
            self = .adjustsFontSizeToFitWidth(value)
        case let (JSONKey.baselineAdjustment.asString, value as String):
            self = .baselineAdjustment(UIBaselineAdjustment(rawValue: value))
        case let (JSONKey.shadowColor.asString, value as String):
            self = .shadowColor(UIColor(rawValue: value))
        case let (JSONKey.shadowOffset.asString, value as [CGFloat]):
            self = .shadowOffset(CGSize(rawValue: value))
        case let (JSONKey.highlightedTextColor.asString, value as String):
            self = .highlightedTextColor(UIColor(rawValue: value))
        case let (JSONKey.attributedText.asString, value as [Attributes]):
            self = .attributedText(Appearance.decodeAttributes(value))

        case let (JSONKey.text.asString, value as String):
            self = .text(value)
        case let (JSONKey.borderStyle.asString, value as String):
            self = .borderStyle(UITextBorderStyle(rawValue: value))
        case let (JSONKey.defaultTextAttributes.asString, value as Attributes):
            self = .defaultTextAttributes(Appearance.decodeAttributes(value))
        case let (JSONKey.placeholder.asString, value as String):
            self = .placeholder(value)
        case let (JSONKey.clearsOnBeginEditing.asString, value as Bool):
            self = .clearsOnBeginEditing(value)
        case let (JSONKey.background.asString, value as JSONDictionary):
            if let image = UIImage(json: value) {
                self = .background(image)
            }
        case let (JSONKey.disabledBackground.asString, value as JSONDictionary):
            if let image = UIImage(json: value) {
                self = .disabledBackground(image)
            }
        case let (JSONKey.typingAttributes.asString, value as Attributes):
            self = .typingAttributes(Appearance.decodeAttributes(value))
        case let (JSONKey.clearButtonMode.asString, value as String):
            self = .clearButtonMode(UITextFieldViewMode(rawValue: value))

        case let (JSONKey.buttonTitle.asString, value as JSONDictionary):
            if let title:String = try? value.parse("title"),
                let states: [String] = try? value.parse("state") {
                self = .buttonTitle(title, UIControlState(rawValue: states))
            }
        case let (JSONKey.buttonTitleColor.asString, value as JSONDictionary):
            if let titleColor:String = try? value.parse("color"),
                let states: [String] = try? value.parse("state") {
                self = .buttonTitleColor(UIColor(rawValue: titleColor), UIControlState(rawValue: states))
            }
        case let (JSONKey.buttonTitleShadowColor.asString, value as JSONDictionary):
            if let titleShadowColor:String = try? value.parse("color"),
                let states: [String] = try? value.parse("state") {
                self = .buttonTitleShadowColor(UIColor(rawValue: titleShadowColor), UIControlState(rawValue: states))
            }
        case let (JSONKey.buttonImage.asString, value as JSONDictionary):
            if let imageJson: JSONDictionary = try? value.parse("image"),
                let states: [String] = try? value.parse("state"),
                let image = UIImage(json: imageJson) {
                self = .buttonImage(image, UIControlState(rawValue: states))
            }
        case let (JSONKey.buttonBackgroundImage.asString, value as JSONDictionary):
            if let imageJson: JSONDictionary = try? value.parse("image"),
                let states: [String] = try? value.parse("state"),
                let image = UIImage(json: imageJson) {
                self = .buttonBackgroundImage(image, UIControlState(rawValue: states))
            }
        case let (JSONKey.buttonAttributedTitle.asString, value as JSONDictionary):
            if let titleAttributes: [Attributes] = try? value.parse("titleAttributes"),
                let states: [String] = try? value.parse("state") {
                self = .buttonAttributedTitle(Appearance.decodeAttributes(titleAttributes), UIControlState(rawValue: states))
            }
        case let (JSONKey.contentEdgeInsets.asString, value as [CGFloat]):
            self = .contentEdgeInsets(UIEdgeInsets(rawValue: value))
        case let (JSONKey.titleEdgeInsets.asString, value as [CGFloat]):
            self = .titleEdgeInsets(UIEdgeInsets(rawValue: value))
        case let (JSONKey.reversesTitleShadowWhenHighlighted.asString, value as Bool):
            self = .reversesTitleShadowWhenHighlighted(value)
        case let (JSONKey.imageEdgeInsets.asString, value as [CGFloat]):
            self = .imageEdgeInsets(UIEdgeInsets(rawValue: value))
        case let (JSONKey.adjustsImageWhenHighlighted.asString, value as Bool):
            self = .adjustsImageWhenHighlighted(value)
        case let (JSONKey.adjustsImageWhenDisabled.asString, value as Bool):
            self = .adjustsImageWhenDisabled(value)
        case let (JSONKey.showsTouchWhenHighlighted.asString, value as Bool):
            self = .showsTouchWhenHighlighted(value)

        case let (JSONKey.ratio.asString, value as CGFloat):
            self = .ratio(value)

        case let (JSONKey.scrollEnabled.asString, value as Bool):
            self = .scrollEnabled(value)
        case let (JSONKey.contentOffset.asString, value as [CGFloat]):
            self = .contentOffset(CGPoint(rawValue: value))
        case let (JSONKey.contentSize.asString, value as [CGFloat]):
            self = .contentSize(CGSize(rawValue: value))
        case let (JSONKey.contentInset.asString, value as [CGFloat]):
            self = .contentInset(UIEdgeInsets(rawValue: value))
        case let (JSONKey.directionalLockEnabled.asString, value as Bool):
            self = .directionalLockEnabled(value)
        case let (JSONKey.bounces.asString, value as Bool):
            self = .bounces(value)
        case let (JSONKey.alwaysBounceVertical.asString, value as Bool):
            self = .alwaysBounceVertical(value)
        case let (JSONKey.alwaysBounceHorizontal.asString, value as Bool):
            self = .alwaysBounceHorizontal(value)
        case let (JSONKey.pagingEnabled.asString, value as Bool):
            self = .pagingEnabled(value)
        case let (JSONKey.showsHorizontalScrollIndicator.asString, value as Bool):
            self = .showsHorizontalScrollIndicator(value)
        case let (JSONKey.showsVerticalScrollIndicator.asString, value as Bool):
            self = .showsVerticalScrollIndicator(value)
        case let (JSONKey.scrollIndicatorInsets.asString, value as [CGFloat]):
            self = .scrollIndicatorInsets(UIEdgeInsets(rawValue: value))
        case let (JSONKey.indicatorStyle.asString, value as String):
            self = .indicatorStyle(UIScrollViewIndicatorStyle(rawValue: value))
        case let (JSONKey.decelerationRate.asString, value as CGFloat):
            self = .decelerationRate(value)
        case let (JSONKey.delaysContentTouches.asString, value as Bool):
            self = .delaysContentTouches(value)
        case let (JSONKey.canCancelContentTouches.asString, value as Bool):
            self = .canCancelContentTouches(value)
        case let (JSONKey.minimumZoomScale.asString, value as CGFloat):
            self = .minimumZoomScale(value)
        case let (JSONKey.maximumZoomScale.asString, value as CGFloat):
            self = .maximumZoomScale(value)
        case let (JSONKey.zoomScale.asString, value as CGFloat):
            self = .zoomScale(value)
        case let (JSONKey.bouncesZoom.asString, value as Bool):
            self = .bouncesZoom(value)
        case let (JSONKey.scrollsToTop.asString, value as Bool):
            self = .scrollsToTop(value)
        case let (JSONKey.keyboardDismissMode.asString, value as String):
            self = .keyboardDismissMode(UIScrollViewKeyboardDismissMode(rawValue: value))

        default:
            assertionFailure("Can't decode json \(json) to Appearance")
        }
    }

    internal func encode() -> JSONDictionary? {
        switch self {
        case let .userInteractionEnabled(value):
            return [JSONKey.userInteractionEnabled.asString: value]
        case let .translatesAutoresizingMaskIntoConstraints(value):
            return [JSONKey.translatesAutoresizingMaskIntoConstraints.asString: value]
        case let .backgroundColor(value):
            return [JSONKey.backgroundColor.asString: value.lg_encode()]
        case let .tintColor(value):
            return [JSONKey.tintColor.asString: value.lg_encode()]
        case let .tintAdjustmentMode(value):
            return [JSONKey.tintAdjustmentMode.asString: value.encode()]
        case let .cornerRadius(value):
            return [JSONKey.cornerRadius.asString: value]
        case let .borderWidth(value):
            return [JSONKey.borderWidth.asString: value]
        case let .borderColor(value):
            return [JSONKey.borderColor.asString: value.lg_encode()]
        case let .multipleTouchEnabled(value):
            return [JSONKey.multipleTouchEnabled.asString: value]
        case let .exclusiveTouch(value):
            return [JSONKey.exclusiveTouch.asString: value]
        case let .clipsToBounds(value):
            return [JSONKey.clipsToBounds.asString: value]
        case let .alpha(value):
            return [JSONKey.alpha.asString: value]
        case let .opaque(value):
            return [JSONKey.opaque.asString: value]
        case let .clearsContextBeforeDrawing(value):
            return [JSONKey.clearsContextBeforeDrawing.asString: value]
        case let .hidden(value):
            return [JSONKey.hidden.asString: value]
        case let .contentMode(value):
            return [JSONKey.contentMode.asString: value.encode()]
        case let .enabled(value):
            return [JSONKey.enabled.asString: value]
        case let .selected(value):
            return [JSONKey.selected.asString: value]
        case let .highlighted(value):
            return [JSONKey.highlighted.asString: value]
        case let .font(value):
            return [JSONKey.font.asString: value.lg_encode()]
        case let .textColor(value):
            return [JSONKey.textColor.asString: value.lg_encode()]
        case let .textAlignment(value):
            return [JSONKey.textAlignment.asString: value.encode()]
        case let .numberOfLines(value):
            return [JSONKey.numberOfLines.asString: value]
        case let .lineBreakMode(value):
            return [JSONKey.lineBreakMode.asString: value.encode()]
        case let .selectedRange(value):
            return [JSONKey.selectedRange.asString: value.encode()]
        case let .editable(value):
            return [JSONKey.editable.asString: value]
        case let .selectable(value):
            return [JSONKey.selectable.asString: value]
        case let .dataDetectorTypes(value):
            return [JSONKey.dataDetectorTypes.asString: value.encode()]
        case let .allowsEditingTextAttributes(value):
            return [JSONKey.allowsEditingTextAttributes.asString: value]
        case let .clearsOnInsertion(value):
            return [JSONKey.clearsOnInsertion.asString: value]
        case let .textContainerInset(value):
            return [JSONKey.textContainerInset.asString: value.encode()]
        case let .linkTextAttributes(value):
            return [JSONKey.linkTextAttributes.asString: Appearance.encodeAttributes(value)]
        case let .lineFragmentPadding(value):
            return [JSONKey.lineFragmentPadding.asString: value]
        case let .minimumScaleFactor(value):
            return [JSONKey.minimumScaleFactor.asString: value]
        case let .adjustsFontSizeToFitWidth(value):
            return [JSONKey.adjustsFontSizeToFitWidth.asString: value]
        case let .baselineAdjustment(value):
            return [JSONKey.baselineAdjustment.asString: value.encode()]
        case let .shadowColor(value):
            return [JSONKey.shadowColor.asString: value.lg_encode()]
        case let .shadowOffset(value):
            return [JSONKey.shadowOffset.asString: value.encode()]
        case let .highlightedTextColor(value):
            return [JSONKey.highlightedTextColor.asString: value.lg_encode()]
        case let .attributedText(value):
            return [JSONKey.attributedText.asString: Appearance.encodeAttributes(value)]
        case let .text(value):
            return [JSONKey.text.asString: value]
        case let .borderStyle(value):
            return [JSONKey.borderStyle.asString: value.encode()]
        case let .defaultTextAttributes(value):
            return [JSONKey.defaultTextAttributes.asString: Appearance.encodeAttributes(value)]
        case let .placeholder(value):
            return [JSONKey.placeholder.asString: value]
        case let .clearsOnBeginEditing(value):
            return [JSONKey.clearsOnBeginEditing.asString: value]
        case let .background(value):
            if let image = value.lg_encode() {
                return [JSONKey.background.asString: image]
            }
        case let .disabledBackground(value):
            if let image = value.lg_encode() {
                return [JSONKey.disabledBackground.asString: image]
            }
        case let .typingAttributes(value):
            return [JSONKey.typingAttributes.asString: Appearance.encodeAttributes(value)]
        case let .clearButtonMode(value):
            return [JSONKey.clearButtonMode.asString: value.encode()]
        case let .buttonTitle(title, state):
            return [JSONKey.buttonTitle.asString: ["title": title, "state": state.encode()]]
        case let .buttonTitleColor(color, state):
            return [JSONKey.buttonTitleColor.asString: ["color": color.lg_encode(), "state": state.encode()]]
        case let .buttonTitleShadowColor(color, state):
            return [JSONKey.buttonTitleShadowColor.asString: ["color": color.lg_encode(), "state": state.encode()]]
        case let .buttonImage(image, state):
            if let image = image.lg_encode() {
                return [JSONKey.buttonImage.asString: ["image": image, "state": state.encode()]]
            }
        case let .buttonBackgroundImage(image, state):
            if let image = image.lg_encode() {
                return [JSONKey.buttonBackgroundImage.asString: ["image": image, "state": state.encode()]]
            }
        case let .buttonAttributedTitle(attributes, state):
            return [JSONKey.buttonAttributedTitle.asString: ["titleAttributes": Appearance.encodeAttributes(attributes), "state": state.encode()]]
        case let .contentEdgeInsets(value):
            return [JSONKey.contentEdgeInsets.asString: value.encode()]
        case let .titleEdgeInsets(value):
            return [JSONKey.titleEdgeInsets.asString: value.encode()]
        case let .reversesTitleShadowWhenHighlighted(value):
            return [JSONKey.reversesTitleShadowWhenHighlighted.asString: value]
        case let .imageEdgeInsets(value):
            return [JSONKey.imageEdgeInsets.asString: value.encode()]
        case let .adjustsImageWhenHighlighted(value):
            return [JSONKey.adjustsImageWhenHighlighted.asString: value]
        case let .adjustsImageWhenDisabled(value):
            return [JSONKey.adjustsImageWhenDisabled.asString: value]
        case let .showsTouchWhenHighlighted(value):
            return [JSONKey.showsTouchWhenHighlighted.asString: value]

        case let .ratio(value):
            return [JSONKey.ratio.asString: value]

        case let .scrollEnabled(value):
            return [JSONKey.scrollEnabled.asString: value]
        case let .contentOffset(value):
            return [JSONKey.contentOffset.asString: value.encode()]
        case let .contentSize(value):
            return [JSONKey.contentSize.asString: value.encode()]
        case let .contentInset(value):
            return [JSONKey.contentInset.asString: value.encode()]
        case let .directionalLockEnabled(value):
            return [JSONKey.directionalLockEnabled.asString: value]
        case let .bounces(value):
            return [JSONKey.bounces.asString: value]
        case let .alwaysBounceVertical(value):
            return [JSONKey.alwaysBounceVertical.asString: value]
        case let .alwaysBounceHorizontal(value):
            return [JSONKey.alwaysBounceHorizontal.asString: value]
        case let .pagingEnabled(value):
            return [JSONKey.pagingEnabled.asString: value]
        case let .showsHorizontalScrollIndicator(value):
            return [JSONKey.showsHorizontalScrollIndicator.asString: value]
        case let .showsVerticalScrollIndicator(value):
            return [JSONKey.showsVerticalScrollIndicator.asString: value]
        case let .scrollIndicatorInsets(value):
            return [JSONKey.scrollIndicatorInsets.asString: value.encode()]
        case let .indicatorStyle(value):
            return [JSONKey.indicatorStyle.asString: value.encode()]
        case let .decelerationRate(value):
            return [JSONKey.decelerationRate.asString: value]
        case let .delaysContentTouches(value):
            return [JSONKey.delaysContentTouches.asString: value]
        case let .canCancelContentTouches(value):
            return [JSONKey.canCancelContentTouches.asString: value]
        case let .minimumZoomScale(value):
            return [JSONKey.minimumZoomScale.asString: value]
        case let .maximumZoomScale(value):
            return [JSONKey.maximumZoomScale.asString: value]
        case let .zoomScale(value):
            return [JSONKey.zoomScale.asString: value]
        case let .bouncesZoom(value):
            return [JSONKey.bouncesZoom.asString: value]
        case let .scrollsToTop(value):
            return [JSONKey.scrollsToTop.asString: value]
        case let .keyboardDismissMode(value):
            return [JSONKey.keyboardDismissMode.asString: value.encode()]
        default:
            break
        }

        assertionFailure("Can't encode appearance \(self) to JSON")
        return nil
    }
}

extension Appearance {

    internal static func encodeAttributes(attributesArray: [Attributes]) -> [Attributes] {
        return attributesArray.map { (attributes) -> Attributes in
            return encodeAttributes(attributes)
        }
    }

    internal static func decodeAttributes(attributesArray: [Attributes]) -> [Attributes] {
        return attributesArray.map { (attributes) -> Attributes in
            return decodeAttributes(attributes)
        }
    }

    internal static func encodeAttributes(attributes: Attributes) -> Attributes {

        var attributesEncoded: Attributes = [:]

        for value in attributes.enumerate() {
            if let font = value.element.1 as? UIFont where value.element.0 == NSFontAttributeName {
                attributesEncoded.updateValue(font.lg_encode(), forKey: value.element.0)
            } else if let color = value.element.1 as? UIColor {
                attributesEncoded.updateValue(color.lg_encode(), forKey: value.element.0)
            } else if let url = value.element.1 as? NSURL {
                attributesEncoded.updateValue(url.lg_encode(), forKey: value.element.0)
            }
        }

        return attributesEncoded
    }

    internal static func decodeAttributes(attributes: Attributes) -> Attributes {

        var attributesDecoded: Attributes = [:]

        for value in attributes.enumerate() {
            if let json = value.element.1 as? JSONDictionary where value.element.0 == NSFontAttributeName,
                let font = UIFont(json: json) {
                attributesDecoded.updateValue(font, forKey: value.element.0)
            } else if let hexString = value.element.1 as? String where value.element.0 == NSForegroundColorAttributeName || value.element.0 == NSBackgroundColorAttributeName {
                attributesDecoded.updateValue(UIColor(rawValue: hexString), forKey: value.element.0)
            } else if let urlPath = value.element.1 as? String where value.element.0 == NSLinkAttributeName, let url = NSURL(string: urlPath) {
                attributesDecoded.updateValue(url, forKey: value.element.0)
            }
        }
        
        return attributesDecoded
    }
}
