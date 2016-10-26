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
                let appearance = Appearance.backgroundColor(UIColor.red)

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
                    .backgroundColor(UIColor.green),
                    .translatesAutoresizingMaskIntoConstraints(false),
                    .userInteractionEnabled(false),
                    .tintColor(UIColor.blue),
                    .tintAdjustmentMode(.normal),
                    .cornerRadius(10),
                    .borderWidth(6),
                    .borderColor(UIColor.red),
                    .multipleTouchEnabled(true),
                    .exclusiveTouch(true),
                    .clipsToBounds(true),
                    .alpha(0.5),
                    .opaque(true),
                    .clearsContextBeforeDrawing(false),
                    .hidden(true),
                    .contentMode(.bottom)
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: view)
                }

                // Then
                expect(view.backgroundColor) == UIColor.green
                expect(view.translatesAutoresizingMaskIntoConstraints) == false
                expect(view.isUserInteractionEnabled) == false
                expect(view.tintColor) == UIColor.blue
                XCTAssert(view.tintAdjustmentMode == .normal)
                expect(view.layer.cornerRadius) == 10
                expect(view.layer.borderWidth) == 6
                XCTAssert(view.layer.borderColor === UIColor.red.cgColor)
                expect(view.isMultipleTouchEnabled) == true
                expect(view.isExclusiveTouch) == true
                expect(view.clipsToBounds) == true
                expect(Float(view.alpha)) == 0.5
                expect(view.isOpaque) == true
                expect(view.clearsContextBeforeDrawing) == false
                expect(view.isHidden) == true
                XCTAssert(view.contentMode == .bottom)

                // When
                for appearance in appearances {
                    appearance.apply(to: view, useDefaultValue: true)
                }

                // Then
                expect(view.backgroundColor).to(beNil())
                expect(view.translatesAutoresizingMaskIntoConstraints) == false
                expect(view.isUserInteractionEnabled) == true
                XCTAssert(view.tintAdjustmentMode == .normal)
                expect(view.layer.cornerRadius) == 0
                expect(view.layer.borderWidth) == 0
                XCTAssert(view.layer.borderColor == nil)
                expect(view.isMultipleTouchEnabled) == false
                expect(view.isExclusiveTouch) == false
                expect(view.clipsToBounds) == false
                expect(Float(view.alpha)) == 1
                expect(view.isOpaque) == true
                expect(view.clearsContextBeforeDrawing) == true
                expect(view.isHidden) == false
                XCTAssert(view.contentMode == .scaleToFill)
            }

            it("should apply appearance correctly to given UILabel") {
                // Given
                let label = UILabel()

                let appearances: [Appearance] = [
                    .enabled(true),
                    .highlighted(true),
                    .font(UIFont(name: "Helvetica", size: 16)!),
                    .textColor(UIColor.green),
                    .textAlignment(.center),
                    .numberOfLines(3),
                    .text("labelText"),
                    .lineBreakMode(.byCharWrapping),
                    .minimumScaleFactor(0.5),
                    .adjustsFontSizeToFitWidth(true),
                    .baselineAdjustment(.alignCenters),
                    .shadowColor(UIColor.brown),
                    .shadowOffset(CGSize(rawValue: [1.0,3.0])),
                    .highlightedTextColor(UIColor.clear)
                    ]

                // When
                for appearance in appearances {
                    appearance.apply(to: label)
                }

                // Then
                expect(label.isEnabled) == true
                expect(label.isHighlighted) == true
                expect(label.font) == UIFont(name: "Helvetica", size: 16)
                expect(label.textColor) == UIColor.green
                expect(label.textAlignment) == NSTextAlignment.center
                expect(label.numberOfLines) == 3
                expect(label.text) == "labelText"
                XCTAssert(label.lineBreakMode == .byCharWrapping)
                expect(label.minimumScaleFactor) == 0.5
                expect(label.adjustsFontSizeToFitWidth) == true
                XCTAssert(label.baselineAdjustment == .alignCenters)
                expect(label.shadowColor) == UIColor.brown
                expect(label.shadowOffset) == CGSize(width: 1.0, height: 3.0)
                expect(label.highlightedTextColor) == UIColor.clear

                Appearance.attributedText([[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]).apply(to: label)
                expect(label.attributedText) == NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!])

                // When
                for appearance in appearances {
                    appearance.apply(to: label, useDefaultValue: true)
                }

                Appearance.attributedText([[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]).apply(to: label, useDefaultValue: true)

                // Then
                expect(label.isEnabled) == true
                expect(label.isHighlighted) == false
                expect(label.font) == UIFont.systemFont(ofSize: 17)
                expect(label.textColor) == UIColor.black
                XCTAssert(label.textAlignment == .left)
                expect(label.numberOfLines) == 1
                expect(label.text).to(beNil())
                XCTAssert(label.lineBreakMode == .byWordWrapping)
                expect(label.minimumScaleFactor) == 0.0
                expect(label.adjustsFontSizeToFitWidth) == false
                XCTAssert(label.baselineAdjustment == .alignBaselines)
                expect(label.shadowColor).to(beNil())
                expect(label.shadowOffset) == CGSize(width: 0.0, height: -1.0)
                expect(label.highlightedTextColor).to(beNil())

                expect(label.attributedText).to(beNil())
            }

            it("should apply appearance correctly to given UITextField") {
                // Given
                let image = UIImage(named: "twitter_favorite", in: Bundle(for: type(of: self)), compatibleWith: nil)!
                let attributes:[Attributes] = [[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]
                let textField = UITextField()

                let appearances: [Appearance] = [
                    .enabled(true),
                    .highlighted(true),
                    .font(UIFont(name: "Helvetica", size: 16)!),
                    .textColor(UIColor.green),
                    .textAlignment(.center),
                    .text("labelText"),
                    .adjustsFontSizeToFitWidth(true),
                    .allowsEditingTextAttributes(true),
                    .clearsOnInsertion(true),
                    .borderStyle(UITextBorderStyle.bezel),
                    .placeholder("placeholder"),
                    .clearsOnBeginEditing(true),
                    .background(image),
                    .disabledBackground(image),
                    .typingAttributes(["c":3 as AnyObject]),
                    .clearButtonMode(UITextFieldViewMode.always),
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: textField)
                }

                // Then
                expect(textField.isEnabled) == true
                expect(textField.isHighlighted) == true
                expect(textField.font) == UIFont(name: "Helvetica", size: 16)
                expect(textField.textColor) == UIColor.green
                expect(textField.textAlignment) == NSTextAlignment.center
                expect(textField.text) == "labelText"
                expect(textField.adjustsFontSizeToFitWidth) == true
                XCTAssert(textField.borderStyle == .bezel)
                expect(textField.placeholder) == "placeholder"
                expect(textField.clearsOnBeginEditing) == true
                expect(textField.background).notTo(beNil())
                expect(textField.disabledBackground).notTo(beNil())
                XCTAssert(textField.clearButtonMode == .always)

                Appearance.attributedText(attributes).apply(to: textField)
                expect(textField.attributedText) == NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!])

                // When
                for appearance in appearances {
                    appearance.apply(to: textField, useDefaultValue: true)
                }

                Appearance.attributedText(attributes).apply(to: textField, useDefaultValue: true)

                // Then
                expect(textField.isEnabled) == true
                expect(textField.isHighlighted) == false
                expect(textField.font) == UIFont.systemFont(ofSize: 17)
                expect(textField.textColor) == UIColor.black
                XCTAssert(textField.textAlignment == .left)
                expect(textField.text) == ""
                expect(textField.adjustsFontSizeToFitWidth) == false
                XCTAssert(textField.borderStyle == .none)
                expect(textField.placeholder).to(beNil())
                expect(textField.clearsOnBeginEditing) == false
                expect(textField.background).to(beNil())
                expect(textField.disabledBackground).to(beNil())
                expect(textField.typingAttributes).to(beNil())
                XCTAssert(textField.clearButtonMode == .never)

                expect(textField.attributedText) == NSAttributedString(string: "", attributes: [:])
            }

            it("should apply appearance correctly to given UITextView") {
                // Given
                let attributes: [Attributes] = [[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]
                let textView = UITextView()
              
                let appearances: [Appearance] = [
                    .font(UIFont(name: "Helvetica", size: 16)!),
                    .textColor(UIColor.green),
                    .textAlignment(.center),
                    .text("labelText"),
                    .numberOfLines(3),
                    .lineBreakMode(.byCharWrapping),
                    .allowsEditingTextAttributes(true),
                    .clearsOnInsertion(true),
                    .selectedRange(NSRange(location: 2, length: 5)),
                    .editable(true),
                    .selectable(true),
                    .dataDetectorTypes(.address),
                    .textContainerInset(UIEdgeInsets(rawValue: [1, 2, 3, 4])),
                    .linkTextAttributes(attributes.first!),
                    .lineFragmentPadding(3.0)
                    ]

                // When
                for appearance in appearances {
                    appearance.apply(to: textView)
                }

                // Then
                expect(textView.font) == UIFont(name: "Helvetica", size: 16)
                expect(textView.textColor) == UIColor.green
                expect(textView.textAlignment) == NSTextAlignment.center
                expect(textView.text) == "labelText"
                expect(textView.textContainer.maximumNumberOfLines) == 3
                XCTAssert(textView.textContainer.lineBreakMode == .byCharWrapping)
                expect(textView.allowsEditingTextAttributes) == true
                expect(textView.clearsOnInsertion) == true
                expect(NSEqualRanges(textView.selectedRange, NSRange(location: 2, length: 5))) == true
                expect(textView.isEditable) == true
                expect(textView.isSelectable) == true
                XCTAssert(textView.dataDetectorTypes == .address)
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
                XCTAssert(textView.textAlignment == .left)
                expect(textView.text) == ""
                expect(textView.textContainer.maximumNumberOfLines) == 0
                XCTAssert(textView.textContainer.lineBreakMode  == .byWordWrapping)
                expect(textView.allowsEditingTextAttributes) == false
                expect(textView.clearsOnInsertion) == false
                expect(NSEqualRanges(textView.selectedRange, NSRange(location: 0, length: 0))) == true
                expect(textView.isEditable) == false
                expect(textView.isSelectable) == true
                XCTAssert(textView.dataDetectorTypes == [])
                expect(UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, UIEdgeInsets.zero)) == true
                expect(textView.textContainer.lineFragmentPadding) == 5

                expect(textView.attributedText) == NSAttributedString(string: "", attributes: [:])
            }

            it("should apply appearance correctly to given UIButton") {
                // Given
                let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                let button = UIButton()
                let appearances: [Appearance] = [
                    .buttonTitle("button", .normal),
                    .buttonTitleColor(UIColor.red, .normal),
                    .buttonTitleShadowColor(UIColor.gray, .highlighted),
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
                expect(button.title(for: .normal)) == "button"
                expect(button.titleColor(for: .normal)) == UIColor.red
                expect(button.titleShadowColor(for: .highlighted)) == UIColor.gray
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
                expect(button.title(for: .normal)).to(beNil())
                expect(button.titleColor(for: .normal)) == UIColor.white
                expect(button.titleShadowColor(for: .highlighted)).to(beNil())
                expect(button.contentEdgeInsets) == UIEdgeInsets.zero
                expect(button.titleEdgeInsets) == UIEdgeInsets.zero
                expect(button.imageEdgeInsets) == UIEdgeInsets.zero
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
                    .indicatorStyle(UIScrollViewIndicatorStyle.black),
                    .decelerationRate(UIScrollViewDecelerationRateFast),
                    .delaysContentTouches(false),
                    .canCancelContentTouches(true),
                    .minimumZoomScale(0.3),
                    .maximumZoomScale(0.7),
                    .zoomScale(1.0),
                    .bouncesZoom(false),
                    .scrollsToTop(false),
                    .keyboardDismissMode(UIScrollViewKeyboardDismissMode.onDrag)
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: scrollView)
                }

                // Then
                expect(scrollView.isScrollEnabled) == true
                expect(scrollView.contentOffset.equalTo(CGPoint(x: 3, y: 10))) == true
                expect(scrollView.contentSize.equalTo(CGSize(width: 10, height: 20))) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsets(rawValue: [1,2,3,4]))) == true
                expect(scrollView.isDirectionalLockEnabled) == false
                expect(scrollView.bounces) == false
                expect(scrollView.alwaysBounceVertical) == true
                expect(scrollView.alwaysBounceHorizontal) == false
                expect(scrollView.isPagingEnabled) == false
                expect(scrollView.showsHorizontalScrollIndicator) == true
                expect(scrollView.showsVerticalScrollIndicator) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.scrollIndicatorInsets, UIEdgeInsets(rawValue: [4,3,2,1]))) == true
                XCTAssert(scrollView.indicatorStyle == .black)
                expect(scrollView.decelerationRate) == UIScrollViewDecelerationRateFast
                expect(scrollView.delaysContentTouches) == false
                expect(scrollView.canCancelContentTouches) == true
                expect(scrollView.minimumZoomScale) == 0.3
                expect(scrollView.maximumZoomScale) == 0.7
                expect(scrollView.zoomScale) == 1.0
                expect(scrollView.bouncesZoom) == false
                expect(scrollView.scrollsToTop) == false
                XCTAssert(scrollView.keyboardDismissMode == .onDrag)

                // When
                for appearance in appearances {
                    appearance.apply(to: scrollView, useDefaultValue: true)
                }

                // Then
                expect(scrollView.isScrollEnabled) == true
                expect(scrollView.contentOffset.equalTo(CGPoint.zero)) == true
                expect(scrollView.contentSize.equalTo(CGSize.zero)) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsets.zero)) == true
                expect(scrollView.isDirectionalLockEnabled) == false
                expect(scrollView.bounces) == true
                expect(scrollView.alwaysBounceVertical) == false
                expect(scrollView.alwaysBounceHorizontal) == false
                expect(scrollView.isPagingEnabled) == false
                expect(scrollView.showsHorizontalScrollIndicator) == true
                expect(scrollView.showsVerticalScrollIndicator) == true
                expect(UIEdgeInsetsEqualToEdgeInsets(scrollView.scrollIndicatorInsets, UIEdgeInsets.zero)) == true
                XCTAssert(scrollView.indicatorStyle == .default)
                XCTAssert(scrollView.decelerationRate == UIScrollViewDecelerationRateNormal)
                expect(scrollView.delaysContentTouches) == true
                expect(scrollView.canCancelContentTouches) == true
                expect(scrollView.minimumZoomScale) == 1.0
                expect(scrollView.maximumZoomScale) == 1.0
                expect(scrollView.zoomScale) == 1.0
                expect(scrollView.bouncesZoom) == true
                expect(scrollView.scrollsToTop) == true
                XCTAssert(scrollView.keyboardDismissMode == .none)
            }
        }

    }
}
