## Supported configurable appearances
Appearance | UIView | UIControl | UILabel | UITextView | UITextField | UIButton | UIImageView | UIScrollView
------------ | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | -------------
userInteractionEnabled | x | x | x | x | x | x | x | x
translatesAutoresizingMaskIntoConstraints | x | x | x | x | x | x | x | x
backgroundColor | x | x | x | x | x | x | x | x
tintColor | x | x | x | x | x | x | x | x
tintAdjustmentMode | x | x | x | x | x | x | x | x
cornerRadius | x | x | x | x | x | x | x | x
borderWidth | x | x | x | x | x | x | x | x
borderColor | x | x | x | x | x | x | x | x
multipleTouchEnabled | x | x | x | x | x | x | x | x
exclusiveTouch | x | x | x | x | x | x | x | x
clipsToBounds | x | x | x | x | x | x | x | x
alpha | x | x | x | x | x | x | x | x
opaque | x | x | x | x | x | x | x | x
clearsContextBeforeDrawing | x | x | x | x | x | x | x | x
hidden | x | x | x | x | x | x | x | x
contentMode | x | x | x | x | x | x | x | x
enabled |  | x | x |  |  |  |  | 
highlighted |  | x | x |  |  |  |  | 
selected |  | x |  |  |  |  |  | 
shadowColor |  |  | x |  |  |  |  | 
shadowOffset |  |  | x |  |  |  |  | 
highlightedTextColor |  |  | x |  |  |  |  | 
minimumScaleFactor |  |  | x |  |  |  |  | 
baselineAdjustment |  |  | x |  |  |  |  | 
adjustsFontSizeToFitWidth |  |  | x |  | x |  |  | 
font |  |  | x | x | x |  |  | 
textColor |  |  | x | x | x |  |  | 
textAlignment |  |  | x | x | x |  |  | 
numberOfLines |  |  | x | x |  |  |  | 
text |  |  | x | x | x |  |  | 
attributedText |  |  | x | x | x |  |  | 
lineBreakMode |  |  | x | x |  |  |  | 
allowsEditingTextAttributes |  |  |  | x | x |  |  | 
clearsOnInsertion |  |  |  | x | x |  |  | 
selectedRange |  |  |  | x |  |  |  | 
editable |  |  |  | x |  |  |  | 
selectable |  |  |  | x |  |  |  | 
dataDetectorTypes |  |  |  | x |  |  |  | 
textContainerInset |  |  |  | x |  |  |  | 
linkTextAttributes |  |  |  | x |  |  |  | 
lineFragmentPadding |  |  |  | x |  |  |  | 
borderStyle |  |  |  |  | x |  |  | 
defaultTextAttributes |  |  |  |  | x |  |  | 
placeholder |  |  |  |  | x |  |  | 
clearsOnBeginEditing |  |  |  |  | x |  |  | 
background |  |  |  |  | x |  |  | 
disabledBackground |  |  |  |  | x |  |  | 
typingAttributes |  |  |  |  | x |  |  | 
clearButtonMode |  |  |  |  | x |  |  | 
buttonTitle |  |  |  |  |  | x |  | 
buttonTitleColor |  |  |  |  |  | x |  | 
buttonTitleShadowColor |  |  |  |  |  | x |  | 
buttonImage |  |  |  |  |  | x |  | 
buttonBackgroundImage |  |  |  |  |  | x |  | 
buttonAttributedTitle |  |  |  |  |  | x |  | 
contentEdgeInsets |  |  |  |  |  | x |  | 
titleEdgeInsets |  |  |  |  |  | x |  | 
imageEdgeInsets |  |  |  |  |  | x |  | 
reversesTitleShadowWhenHighlighted |  |  |  |  |  | x |  | 
adjustsImageWhenHighlighted |  |  |  |  |  | x |  | 
adjustsImageWhenDisabled |  |  |  |  |  | x |  | 
showsTouchWhenHighlighted |  |  |  |  |  | x |  | 
ratio |  |  |  |  |  |  | x | 
scrollEnabled |  |  |  |  |  |  |  | x
contentOffset |  |  |  |  |  |  |  | x
contentSize |  |  |  |  |  |  |  | x
contentInset |  |  |  |  |  |  |  | x
directionalLockEnabled |  |  |  |  |  |  |  | x
bounces |  |  |  |  |  |  |  | x
alwaysBounceVertical |  |  |  |  |  |  |  | x
alwaysBounceHorizontal |  |  |  |  |  |  |  | x
pagingEnabled |  |  |  |  |  |  |  | x
showsHorizontalScrollIndicator |  |  |  |  |  |  |  | x
showsVerticalScrollIndicator |  |  |  |  |  |  |  | x
scrollIndicatorInsets |  |  |  |  |  |  |  | x
indicatorStyle |  |  |  |  |  |  |  | x
decelerationRate |  |  |  |  |  |  |  | x
delaysContentTouches |  |  |  |  |  |  |  | x
canCancelContentTouches |  |  |  |  |  |  |  | x
minimumZoomScale |  |  |  |  |  |  |  | x
maximumZoomScale |  |  |  |  |  |  |  | x
zoomScale |  |  |  |  |  |  |  | x
bouncesZoom |  |  |  |  |  |  |  | x
scrollsToTop |  |  |  |  |  |  |  | x
keyboardDismissMode |  |  |  |  |  |  |  | x

## Use custom appearance

You can also implement your self the custom appearance by overriding and implementing `UIView.lg_setupCustomStyle` & `UIView.lg_removeCustomStyle`.

```swift
let blueBlock = "blue".build(UIImageView).style([.custom(["shadowColor": UIColor.brownColor(), "shadowOpacity": 1.0])])

extension UIView {
    public func lg_setupCustomStyle(style: [String: AnyObject]) {
        if let view = self as? UIImageView,
            let color = style["shadowColor"] as? UIColor,
            let opacity = style["shadowOpacity"] as? Float {
            view.layer.shadowColor = color.CGColor
            view.layer.shadowOpacity = opacity
        }
    }

    public func lg_removeCustomStyle(style: [String: AnyObject]) {
        if let view = self as? UIImageView,
            let _ = style["shadowColor"] as? UIColor,
            let _ = style["shadowOpacity"] as? Float {
            view.layer.shadowColor = UIColor.blackColor().CGColor
            view.layer.shadowOpacity = 0.0
        }
    }
}

```

Warning: should be careful to implement these two methods as a pair, if you tell the framework how to apply a custom style, you need also to tell how to unapply this custom style. Otherwise you may have some unexpected effects.