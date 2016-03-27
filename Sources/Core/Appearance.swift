//
//  Appearance.swift
//  LeeGo
//
//  Created by Victor WANG on 13/03/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation

public typealias Attributes = [String: AnyObject]

public enum Appearance {
    // UIView
    case userInteractionEnabled(Bool), translatesAutoresizingMaskIntoConstraints(Bool), backgroundColor(UIColor), tintColor(UIColor), tintAdjustmentMode(UIViewTintAdjustmentMode), cornerRadius(CGFloat), borderWidth(CGFloat), borderColor(UIColor), multipleTouchEnabled(Bool), exclusiveTouch(Bool), clipsToBounds(Bool), alpha(CGFloat), opaque(Bool), clearsContextBeforeDrawing(Bool), hidden(Bool), contentMode(UIViewContentMode)

    // UIControl
    case enabled(Bool), selected(Bool), highlighted(Bool)

    // UILabel & UITextView & UITextField
    case font(UIFont), textColor(UIColor), textAlignment(NSTextAlignment), numberOfLines(Int), lineBreakMode(NSLineBreakMode), selectedRange(NSRange), editable(Bool), selectable(Bool), dataDetectorTypes(UIDataDetectorTypes), allowsEditingTextAttributes(Bool), clearsOnInsertion(Bool), textContainerInset(UIEdgeInsets), linkTextAttributes(Attributes), lineFragmentPadding(CGFloat), minimumScaleFactor(CGFloat), adjustsFontSizeToFitWidth(Bool), baselineAdjustment(UIBaselineAdjustment), shadowColor(UIColor), shadowOffset(CGSize), highlightedTextColor(UIColor)

    case attributedText([Attributes]) // TODO: handle also NSParagrapheStyle

    case text(String), borderStyle(UITextBorderStyle), defaultTextAttributes(Attributes), placeholder(String), attributedPlaceholder([Attributes]), clearsOnBeginEditing(Bool), background(UIImage), disabledBackground(UIImage), typingAttributes(Attributes), clearButtonMode(UITextFieldViewMode)

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
        case (let .selected(selected), let control as UIControl):
            control.selected = selected

        // UILabel
        case (let .shadowColor(color), let label as UILabel):
            label.shadowColor = color
        case (let .shadowOffset(size), let label as UILabel):
            label.shadowOffset = size
        case (let .highlightedTextColor(color), let label as UILabel):
            label.highlightedTextColor = color
        case (let .minimumScaleFactor(factor), let label as UILabel):
            label.minimumScaleFactor = factor
        case (let .baselineAdjustment(adjustment), let label as UILabel):
            label.baselineAdjustment = adjustment

        // UILabel & UITextField & UITextView
        case (let .enabled(enabled), let view):
            if let label = view as? UILabel {
                label.enabled = enabled
            } else if let control = view as? UIControl {
                control.enabled = enabled
            }
        case (let .highlighted(highlighted), let view):
            if let label = view as? UILabel {
                label.highlighted = highlighted
            } else if let control = view as? UIControl {
                control.highlighted = highlighted
            }
        case (let .adjustsFontSizeToFitWidth(should), let view):
            if let label = view as? UILabel {
                label.adjustsFontSizeToFitWidth = should
            } else if let textField = view as? UITextField {
                textField.adjustsFontSizeToFitWidth = should
            }
        case (let .font(font), let view):
            if let label = view as? UILabel {
                label.font = font
            } else if let textField = view as? UITextField {
                textField.font = font
            } else if let textView = view as? UITextView {
                textView.font = font
            }
        case (let .textColor(color), let view):
            if let label = view as? UILabel {
                label.textColor = color
            } else if let textField = view as? UITextField {
                textField.textColor = color
            } else if let textView = view as? UITextView {
                textView.textColor = color
            }
        case (let .textAlignment(align), let view):
            if let label = view as? UILabel {
                label.textAlignment = align
            } else if let textField = view as? UITextField {
                textField.textAlignment = align
            } else if let textView = view as? UITextView {
                textView.textAlignment = align
            }
        case (let .numberOfLines(number), let view):
            if let label = view as? UILabel {
                label.numberOfLines = number
            } else if let textView = view as? UITextView {
                textView.textContainer.maximumNumberOfLines = number
            }
        case (let .text(text), let view):
            if let label = view as? UILabel {
                label.text = text
            } else if let textField = view as? UITextField {
                textField.text = text
            } else if let textView = view as? UITextView {
                textView.text = text
            }
        case (let .attributedText(attributes), let view):
            if let label = view as? UILabel {
                label.attributedText = attributedStringFromList(attributes)
            } else if let textField = view as? UITextField {
                textField.attributedText = attributedStringFromList(attributes)
            } else if let textView = view as? UITextView {
                textView.attributedText = attributedStringFromList(attributes)
            }
        case (let .lineBreakMode(mode), let view):
            if let label = view as? UILabel {
                label.lineBreakMode = mode
            } else if let textView = view as? UITextView {
                textView.textContainer.lineBreakMode = mode
            }
        case (let .allowsEditingTextAttributes(allows), let view):
            if let textField = view as? UITextField {
                textField.allowsEditingTextAttributes = allows
            } else if let textView = view as? UITextView {
                textView.allowsEditingTextAttributes = allows
            }
        case (let .clearsOnInsertion(clearsOnInsertion), let view):
            if let textField = view as? UITextField {
                textField.clearsOnInsertion = clearsOnInsertion
            } else if let textView = view as? UITextView {
                textView.clearsOnInsertion = clearsOnInsertion
            }

        // UITextView
        case (let .selectedRange(range), let textView as UITextView):
            textView.selectedRange = range
        case (let .editable(editable), let textView as UITextView):
            textView.editable = editable
        case (let .selectable(selectable), let textView as UITextView):
            textView.selectable = selectable
        case (let .dataDetectorTypes(types), let textView as UITextView):
            textView.dataDetectorTypes = types
        case (let .textContainerInset(inset), let textView as UITextView):
            textView.textContainerInset = inset
        case (let .linkTextAttributes(attrs), let textView as UITextView):
            textView.linkTextAttributes = attrs
        case (let .lineFragmentPadding(padding), let textView as UITextView):
            textView.textContainer.lineFragmentPadding = padding

            // UITextField
        case (let .borderStyle(style), let textField as UITextField):
            textField.borderStyle = style
        case (let .defaultTextAttributes(attributes), let textField as UITextField):
            textField.defaultTextAttributes = attributes
        case (let .placeholder(text), let textField as UITextField):
            textField.placeholder = text
        case (let .attributedPlaceholder(attributes), let textField as UITextField):
            textField.attributedPlaceholder = attributedStringFromList(attributes)
        case (let .clearsOnBeginEditing(should), let textField as UITextField):
            textField.clearsOnBeginEditing = should
        case (let .background(image), let textField as UITextField):
            textField.background = image
        case (let .disabledBackground(image), let textField as UITextField):
            textField.disabledBackground = image
        case (let .typingAttributes(attributes), let textField as UITextField):
            textField.typingAttributes = attributes
        case (let .clearButtonMode(mode), let textField as UITextField):
            textField.clearButtonMode = mode

        // UIButton
        case (let .buttonType(type), _ as UIButton):
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
            // TODO: If there is already ratio constraint, should update instead of adding
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
        case (let .contentOffset(offset), let scrollView as UIScrollView):
            scrollView.contentOffset = offset
        case (let .contentSize(size), let scrollView as UIScrollView):
            scrollView.contentSize = size
        case (let .contentInset(inset), let scrollView as UIScrollView):
            scrollView.contentInset = inset
        case (let .directionalLockEnabled(enabled), let scrollView as UIScrollView):
            scrollView.directionalLockEnabled = enabled
        case (let .bounces(bounces), let scrollView as UIScrollView):
            scrollView.bounces = bounces
        case (let .alwaysBounceVertical(alwaysBounceVertical), let scrollView as UIScrollView):
            scrollView.alwaysBounceVertical = alwaysBounceVertical
        case (let .alwaysBounceHorizontal(alwaysBounceHorizontal), let scrollView as UIScrollView):
            scrollView.alwaysBounceHorizontal = alwaysBounceHorizontal
        case (let .pagingEnabled(pagingEnabled), let scrollView as UIScrollView):
            scrollView.pagingEnabled = pagingEnabled
        case (let .showsHorizontalScrollIndicator(show), let scrollView as UIScrollView):
            scrollView.showsHorizontalScrollIndicator = show
        case (let .showsVerticalScrollIndicator(show), let scrollView as UIScrollView):
            scrollView.showsVerticalScrollIndicator = show
        case (let .scrollIndicatorInsets(insets), let scrollView as UIScrollView):
            scrollView.scrollIndicatorInsets = insets
        case (let .indicatorStyle(style), let scrollView as UIScrollView):
            scrollView.indicatorStyle = style
        case (let .decelerationRate(rate), let scrollView as UIScrollView):
            scrollView.decelerationRate = rate
        case (let .delaysContentTouches(delaysContentTouches), let scrollView as UIScrollView):
            scrollView.delaysContentTouches = delaysContentTouches
        case (let .canCancelContentTouches(canCancelContentTouches), let scrollView as UIScrollView):
            scrollView.canCancelContentTouches = canCancelContentTouches
        case (let .minimumZoomScale(minimumZoomScale), let scrollView as UIScrollView):
            scrollView.minimumZoomScale = minimumZoomScale
        case (let .maximumZoomScale(maximumZoomScale), let scrollView as UIScrollView):
            scrollView.maximumZoomScale = maximumZoomScale
        case (let .zoomScale(zoomScale), let scrollView as UIScrollView):
            scrollView.zoomScale = zoomScale
        case (let .bouncesZoom(bouncesZoom), let scrollView as UIScrollView):
            scrollView.bouncesZoom = bouncesZoom
        case (let .scrollsToTop(scrollsToTop), let scrollView as UIScrollView):
            scrollView.scrollsToTop = scrollsToTop
        case (let .keyboardDismissMode(keyboardDismissMode), let scrollView as UIScrollView):
            scrollView.keyboardDismissMode = keyboardDismissMode

        // Custom
        case (let .custom(dictionary), _):
            useDefaultValue ? component.removeCustomStyle(dictionary) : component.setupCustomStyle(dictionary)

        default:
            assertionFailure("Unknown appearance \(self) for component \(component)")
            break
        }
    }

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

extension Appearance: Hashable {
    public var hashValue: Int {
        return self.toString().hashValue
    }
}

public func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    // TODO: how to implement the real equatable
    return lhs.toString() == rhs.toString()
}

