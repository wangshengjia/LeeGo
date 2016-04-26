//
//  Test.swift
//  LeeGo
//
//  Created by Victor WANG on 24/02/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class AppearanceSpec: QuickSpec {
    override func spec() {
        describe("Appearance") {
            it("should return hashValue correctly.") {
                // Given
                let appearance = Appearance.backgroundColor(UIColor.redColor())

                // When
                let hashValue = appearance.hashValue

                // Then
                expect(hashValue) == "backgroundColor".hashValue
            }
        }

        describe("Appearacne tests") {

            it("should apply appearances correctly to given UIView") {
                // Given
                let view = UIView()
                let appearances: [Appearance] = [
                    .backgroundColor(UIColor.greenColor()),
                    .translatesAutoresizingMaskIntoConstraints(false),
                    .userInteractionEnabled(false),
                    .tintColor(UIColor.blueColor()),
                    .tintAdjustmentMode(.Normal),
                    .cornerRadius(10),
                    .borderWidth(6),
                    .borderColor(UIColor.redColor()),
                    .multipleTouchEnabled(true),
                    .exclusiveTouch(true),
                    .clipsToBounds(true),
                    .alpha(0.5),
                    .opaque(true),
                    .clearsContextBeforeDrawing(false),
                    .hidden(true),
                    .contentMode(.Bottom)
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: view)
                }

                // Then
                expect(view.backgroundColor) == UIColor.greenColor()
                expect(view.translatesAutoresizingMaskIntoConstraints) == false
                expect(view.userInteractionEnabled) == false
                expect(view.tintColor) == UIColor.blueColor()
                XCTAssert(view.tintAdjustmentMode == .Normal)
                expect(view.layer.cornerRadius) == 10
                expect(view.layer.borderWidth) == 6
                XCTAssert(view.layer.borderColor === UIColor.redColor().CGColor)
                expect(view.multipleTouchEnabled) == true
                expect(view.exclusiveTouch) == true
                expect(view.clipsToBounds) == true
                expect(Float(view.alpha)) == 0.5
                expect(view.opaque) == true
                expect(view.clearsContextBeforeDrawing) == false
                expect(view.hidden) == true
                XCTAssert(view.contentMode == .Bottom)

                // When
                for appearance in appearances {
                    appearance.apply(to: view, useDefaultValue: true)
                }

                // Then
                expect(view.backgroundColor).to(beNil())
                expect(view.translatesAutoresizingMaskIntoConstraints) == false
                expect(view.userInteractionEnabled) == true
                XCTAssert(view.tintAdjustmentMode == .Normal)
                expect(view.layer.cornerRadius) == 0
                expect(view.layer.borderWidth) == 0
                XCTAssert(view.layer.borderColor == nil)
                expect(view.multipleTouchEnabled) == false
                expect(view.exclusiveTouch) == false
                expect(view.clipsToBounds) == false
                expect(Float(view.alpha)) == 1
                expect(view.opaque) == true
                expect(view.clearsContextBeforeDrawing) == true
                expect(view.hidden) == false
                XCTAssert(view.contentMode == .ScaleToFill)
            }

            it("should apply appearance correctly to given UILabel") {
                // Given
                let label = UILabel()

                let appearances: [Appearance] = [
                    .enabled(true),
                    .highlighted(true),
                    .font(UIFont(name: "Helvetica", size: 16)!),
                    .textColor(UIColor.greenColor()),
                    .textAlignment(.Center),
                    .numberOfLines(3),
                    .text("labelText"),
                    .lineBreakMode(.ByCharWrapping),
                    .minimumScaleFactor(0.5),
                    .adjustsFontSizeToFitWidth(true),
                    .baselineAdjustment(.AlignCenters),
                    .shadowColor(UIColor.brownColor()),
                    .shadowOffset(CGSize(rawValue: [1.0,3.0])),
                    .highlightedTextColor(UIColor.clearColor())
                    ]

                // When
                for appearance in appearances {
                    appearance.apply(to: label)
                }

                // Then
                expect(label.enabled) == true
                expect(label.highlighted) == true
                expect(label.font) == UIFont(name: "Helvetica", size: 16)
                expect(label.textColor) == UIColor.greenColor()
                expect(label.textAlignment) == NSTextAlignment.Center
                expect(label.numberOfLines) == 3
                expect(label.text) == "labelText"
                XCTAssert(label.lineBreakMode == .ByCharWrapping)
                expect(label.minimumScaleFactor) == 0.5
                expect(label.adjustsFontSizeToFitWidth) == true
                XCTAssert(label.baselineAdjustment == .AlignCenters)
                expect(label.shadowColor) == UIColor.brownColor()
                expect(label.shadowOffset) == CGSize(width: 1.0, height: 3.0)
                expect(label.highlightedTextColor) == UIColor.clearColor()

                Appearance.attributedText([[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]).apply(to: label)
                expect(label.attributedText) == NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!])

                // When
                for appearance in appearances {
                    appearance.apply(to: label, useDefaultValue: true)
                }

                Appearance.attributedText([[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]).apply(to: label, useDefaultValue: true)

                // Then
                expect(label.enabled) == true
                expect(label.highlighted) == false
                expect(label.font) == UIFont.systemFontOfSize(17)
                expect(label.textColor) == UIColor.blackColor()
                XCTAssert(label.textAlignment == .Left)
                expect(label.numberOfLines) == 1
                expect(label.text).to(beNil())
                XCTAssert(label.lineBreakMode == .ByWordWrapping)
                expect(label.minimumScaleFactor) == 0.0
                expect(label.adjustsFontSizeToFitWidth) == false
                XCTAssert(label.baselineAdjustment == .AlignBaselines)
                expect(label.shadowColor).to(beNil())
                expect(label.shadowOffset) == CGSize(width: 0.0, height: -1.0)
                expect(label.highlightedTextColor).to(beNil())

                expect(label.attributedText).to(beNil())
            }

            it("should apply appearance correctly to given UITextField") {
                // Given
                let image = UIImage(named: "twitter_favorite", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!
                let attributes:[Attributes] = [[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]
                let textField = UITextField()

                let appearances: [Appearance] = [
                    .enabled(true),
                    .highlighted(true),
                    .font(UIFont(name: "Helvetica", size: 16)!),
                    .textColor(UIColor.greenColor()),
                    .textAlignment(.Center),
                    .text("labelText"),
                    .adjustsFontSizeToFitWidth(true),
                    .allowsEditingTextAttributes(true),
                    .clearsOnInsertion(true),
                    .borderStyle(UITextBorderStyle.Bezel),
                    .placeholder("placeholder"),
                    .clearsOnBeginEditing(true),
                    .background(image),
                    .disabledBackground(image),
                    .typingAttributes(["c":3]),
                    .clearButtonMode(UITextFieldViewMode.Always),
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: textField)
                }

                // Then
                expect(textField.enabled) == true
                expect(textField.highlighted) == true
                expect(textField.font) == UIFont(name: "Helvetica", size: 16)
                expect(textField.textColor) == UIColor.greenColor()
                expect(textField.textAlignment) == NSTextAlignment.Center
                expect(textField.text) == "labelText"
                expect(textField.adjustsFontSizeToFitWidth) == true
                XCTAssert(textField.borderStyle == .Bezel)
                expect(textField.placeholder) == "placeholder"
                expect(textField.clearsOnBeginEditing) == true
                expect(textField.background).notTo(beNil())
                expect(textField.disabledBackground).notTo(beNil())
                XCTAssert(textField.clearButtonMode == .Always)

                Appearance.attributedText(attributes).apply(to: textField)
                expect(textField.attributedText) == NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!])

                // When
                for appearance in appearances {
                    appearance.apply(to: textField, useDefaultValue: true)
                }

                Appearance.attributedText(attributes).apply(to: textField, useDefaultValue: true)

                // Then
                expect(textField.enabled) == true
                expect(textField.highlighted) == false
                expect(textField.font) == UIFont.systemFontOfSize(17)
                expect(textField.textColor) == UIColor.blackColor()
                XCTAssert(textField.textAlignment == .Left)
                expect(textField.text) == ""
                expect(textField.adjustsFontSizeToFitWidth) == false
                XCTAssert(textField.borderStyle == .None)
                expect(textField.placeholder).to(beNil())
                expect(textField.clearsOnBeginEditing) == false
                expect(textField.background).to(beNil())
                expect(textField.disabledBackground).to(beNil())
                expect(textField.typingAttributes).to(beNil())
                XCTAssert(textField.clearButtonMode == .Never)

                expect(textField.attributedText) == NSAttributedString(string: "", attributes: [:])
            }

            it("should apply appearance correctly to given UITextView") {
                // Given
                let attributes: [Attributes] = [[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]
                let textView = UITextView()

                let appearances: [Appearance] = [
                    .font(UIFont(name: "Helvetica", size: 16)!),
                    .textColor(UIColor.greenColor()),
                    .textAlignment(.Center),
                    .text("labelText"),
                    .numberOfLines(3),
                    .lineBreakMode(.ByCharWrapping),
                    .allowsEditingTextAttributes(true),
                    .clearsOnInsertion(true),
                    .selectedRange(NSRange(location: 2, length: 5)),
                    .editable(true),
                    .selectable(true),
                    .dataDetectorTypes(.Address),
                    .textContainerInset(UIEdgeInsets(rawValue: [1, 2, 3, 4])),
                    .linkTextAttributes(attributes.first!),
                    .lineFragmentPadding(3)
                    ]

                // When
                for appearance in appearances {
                    appearance.apply(to: textView)
                }

                // Then
                expect(textView.font) == UIFont(name: "Helvetica", size: 16)
                expect(textView.textColor) == UIColor.greenColor()
                expect(textView.textAlignment) == NSTextAlignment.Center
                expect(textView.text) == "labelText"
                expect(textView.textContainer.maximumNumberOfLines) == 3
                XCTAssert(textView.textContainer.lineBreakMode == .ByCharWrapping)
                expect(textView.allowsEditingTextAttributes) == true
                expect(textView.clearsOnInsertion) == true
                expect(NSEqualRanges(textView.selectedRange, NSRange(location: 2, length: 5))) == true
                expect(textView.editable) == true
                expect(textView.selectable) == true
                XCTAssert(textView.dataDetectorTypes == .Address)
                expect(UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, UIEdgeInsets(rawValue: [1, 2, 3, 4]))) == true
                expect(textView.textContainer.lineFragmentPadding) == 3

                Appearance.attributedText(attributes).apply(to: textView)
                expect(textView.attributedText) == NSAttributedString(string: "", attributes: attributes.first)

                // When
                for appearance in appearances {
                    appearance.apply(to: textView, useDefaultValue: true)
                }

                Appearance.attributedText(attributes).apply(to: textView, useDefaultValue: true)

                // Then
                expect(textView.font).to(beNil())
                expect(textView.textColor).to(beNil())
                XCTAssert(textView.textAlignment == .Left)
                expect(textView.text) == ""
                expect(textView.textContainer.maximumNumberOfLines) == 0
                XCTAssert(textView.textContainer.lineBreakMode  == .ByWordWrapping)
                expect(textView.allowsEditingTextAttributes) == false
                expect(textView.clearsOnInsertion) == false
                expect(NSEqualRanges(textView.selectedRange, NSRange(location: 0, length: 0))) == true
                expect(textView.editable) == false
                expect(textView.selectable) == true
                XCTAssert(textView.dataDetectorTypes == .None)
                expect(UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, UIEdgeInsetsZero)) == true
                expect(textView.textContainer.lineFragmentPadding) == 5

                expect(textView.attributedText) == NSAttributedString(string: "", attributes: [:])
            }

            it("should apply appearance correctly to given UIButton") {
                // Given
                let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                let button = UIButton()
                let appearances: [Appearance] = [
                    .buttonTitle("button", .Normal),
                    .buttonTitleColor(UIColor.redColor(), .Normal),
                    .buttonTitleShadowColor(UIColor.grayColor(), .Highlighted),
                    .contentEdgeInsets(insets),
                    .titleEdgeInsets(insets),
                    .imageEdgeInsets(insets),
                    .reversesTitleShadowWhenHighlighted(false),
                    .adjustsImageWhenHighlighted(true),
                    .adjustsImageWhenDisabled(true),
                    .showsTouchWhenHighlighted(true)
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: button)
                }

                // Then
                expect(button.titleForState(.Normal)) == "button"
                expect(button.titleColorForState(.Normal)) == UIColor.redColor()
                expect(button.titleShadowColorForState(.Highlighted)) == UIColor.grayColor()
                expect(button.contentEdgeInsets) == insets
                expect(button.titleEdgeInsets) == insets
                expect(button.imageEdgeInsets) == insets
                expect(button.reversesTitleShadowWhenHighlighted) == false
                expect(button.adjustsImageWhenHighlighted) == true
                expect(button.adjustsImageWhenDisabled) == true
                expect(button.showsTouchWhenHighlighted) == true

                // When
                for appearance in appearances {
                    appearance.apply(to: button, useDefaultValue: true)
                }

                // Then
                expect(button.titleForState(.Normal)).to(beNil())
                expect(button.titleColorForState(.Normal)) == UIColor.whiteColor()
                expect(button.titleShadowColorForState(.Highlighted)).to(beNil())
                expect(button.contentEdgeInsets) == UIEdgeInsetsZero
                expect(button.titleEdgeInsets) == UIEdgeInsetsZero
                expect(button.imageEdgeInsets) == UIEdgeInsetsZero
                expect(button.reversesTitleShadowWhenHighlighted) == false
                expect(button.adjustsImageWhenHighlighted) == true
                expect(button.adjustsImageWhenDisabled) == true
                expect(button.showsTouchWhenHighlighted) == false
            }

            it("should apply appearance correctly to given UIImageView") {

                //Given
                let imageView = UIImageView()
                let appearances: [Appearance] = [.ratio(1.5)]

                // When
                for appearance in appearances {
                    appearance.apply(to: imageView)
                }

                // Then
                expect(imageView.constraints.count) == 1
                expect(imageView.constraints.first!.identifier?.hasPrefix("LG_Ratio")) == true
                expect(imageView.constraints.first!.multiplier) == 1.5
                expect(imageView.constraints.first!.priority) == 990

                // When
                for appearance in appearances {
                    appearance.apply(to: imageView, useDefaultValue: true)
                }

                // Then
                expect(imageView.constraints.count) == 0
            }

            it("should apply appearance correctly to given UIScrollView") {

                //Given
                let scrollView = UIScrollView()
                let appearances: [Appearance] = [
                    .scrollEnabled(true),
                    .contentOffset(CGPoint(x: 3, y: 10)),
                    .contentSize(CGSize(width: 10, height: 20)),
                    .contentInset(UIEdgeInsets(rawValue: [1,2,3,4])),
                    .directionalLockEnabled(false),
                    .bounces(false),
                    .alwaysBounceVertical(true),
                    .alwaysBounceHorizontal(false),
                    .pagingEnabled(false),
                    .showsHorizontalScrollIndicator(true),
                    .showsVerticalScrollIndicator(true),
                    .scrollIndicatorInsets(UIEdgeInsets(rawValue: [4, 3, 2, 1])),
                    .indicatorStyle(UIScrollViewIndicatorStyle.Black),
                    .decelerationRate(UIScrollViewDecelerationRateFast),
                    .delaysContentTouches(false),
                    .canCancelContentTouches(true),
                    .minimumZoomScale(0.3),
                    .maximumZoomScale(0.7),
                    .zoomScale(1.0),
                    .bouncesZoom(false),
                    .scrollsToTop(false),
                    .keyboardDismissMode(UIScrollViewKeyboardDismissMode.OnDrag)
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: scrollView)
                }

                // Then
                expect(scrollView.scrollEnabled) == true
                expect(CGPointEqualToPoint(scrollView.contentOffset, CGPoint(x: 3, y: 10))) == true
                expect(CGSizeEqualToSize(scrollView.contentSize, CGSize(width: 10, height: 20))) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsets(rawValue: [1,2,3,4]))) == true
                expect(scrollView.directionalLockEnabled) == false
                expect(scrollView.bounces) == false
                expect(scrollView.alwaysBounceVertical) == true
                expect(scrollView.alwaysBounceHorizontal) == false
                expect(scrollView.pagingEnabled) == false
                expect(scrollView.showsHorizontalScrollIndicator) == true
                expect(scrollView.showsVerticalScrollIndicator) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.scrollIndicatorInsets, UIEdgeInsets(rawValue: [4,3,2,1]))) == true
                XCTAssert(scrollView.indicatorStyle == .Black)
                expect(scrollView.decelerationRate) == UIScrollViewDecelerationRateFast
                expect(scrollView.delaysContentTouches) == false
                expect(scrollView.canCancelContentTouches) == true
                expect(scrollView.minimumZoomScale) == 0.3
                expect(scrollView.maximumZoomScale) == 0.7
                expect(scrollView.zoomScale) == 1.0
                expect(scrollView.bouncesZoom) == false
                expect(scrollView.scrollsToTop) == false
                XCTAssert(scrollView.keyboardDismissMode == .OnDrag)

                // When
                for appearance in appearances {
                    appearance.apply(to: scrollView, useDefaultValue: true)
                }

                // Then
                expect(scrollView.scrollEnabled) == true
                expect(CGPointEqualToPoint(scrollView.contentOffset, CGPointZero)) == true
                expect(CGSizeEqualToSize(scrollView.contentSize, CGSizeZero)) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsetsZero)) == true
                expect(scrollView.directionalLockEnabled) == false
                expect(scrollView.bounces) == true
                expect(scrollView.alwaysBounceVertical) == false
                expect(scrollView.alwaysBounceHorizontal) == false
                expect(scrollView.pagingEnabled) == false
                expect(scrollView.showsHorizontalScrollIndicator) == true
                expect(scrollView.showsVerticalScrollIndicator) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.scrollIndicatorInsets, UIEdgeInsetsZero)) == true
                XCTAssert(scrollView.indicatorStyle == .Default)
                XCTAssert(scrollView.decelerationRate == UIScrollViewDecelerationRateNormal)
                expect(scrollView.delaysContentTouches) == true
                expect(scrollView.canCancelContentTouches) == true
                expect(scrollView.minimumZoomScale) == 1.0
                expect(scrollView.maximumZoomScale) == 1.0
                expect(scrollView.zoomScale) == 1.0
                expect(scrollView.bouncesZoom) == true
                expect(scrollView.scrollsToTop) == true
                XCTAssert(scrollView.keyboardDismissMode == .None)
            }
        }

    }
}