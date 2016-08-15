//
//  ConvertibleSpec.swift
//  LeeGo
//
//  Created by Victor WANG on 24/03/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import XCTest

import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class ConvertibleSpec: QuickSpec {
    override func spec() {

        describe("Appearance is convertible") {

            // Given
            let image = UIImage(named: "twitter_favorite", in: Bundle(for: self.dynamicType), compatibleWith: nil)!

            let style: [Appearance] = [.userInteractionEnabled(true),
                                       .translatesAutoresizingMaskIntoConstraints(true),
                                       .backgroundColor(UIColor.blue),
                                       .tintColor(UIColor.red),
                                       .tintAdjustmentMode(.dimmed),
                                       .cornerRadius(5),
                                       .borderWidth(1),
                                       .borderColor(UIColor.gray),
                                       .multipleTouchEnabled(false),
                                       .exclusiveTouch(false),
                                       .clipsToBounds(true),
                                       .alpha(0.4),
                                       .opaque(true),
                                       .clearsContextBeforeDrawing(false),
                                       .hidden(true),
                                       .contentMode(.bottomLeft),
                                       .enabled(true),
                                       .selected(false),
                                       .highlighted(true),
                                       .font(UIFont.systemFont(ofSize: 10)),
                                       .textColor(UIColor.red),
                                       .textAlignment(.center),
                                       .numberOfLines(10),
                                       .lineBreakMode(.byClipping),
                                       .selectedRange(NSRange(location:0, length: 4)),
                                       .editable(true),
                                       .selectable(true),
                                       .dataDetectorTypes(.address),
                                       .allowsEditingTextAttributes(false),
                                       .clearsOnInsertion(true),
                                       .textContainerInset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 20)),
                                       .linkTextAttributes([
                                        NSFontAttributeName: UIFont.systemFont(ofSize: 13),
                                        NSForegroundColorAttributeName: UIColor.yellow,
                                        NSBackgroundColorAttributeName: UIColor.blue
                                        ]),
                                       .lineFragmentPadding(12.0),
                                       .minimumScaleFactor(0.3),
                                       .adjustsFontSizeToFitWidth(true),
                                       .baselineAdjustment(.alignCenters),
                                       .shadowColor(UIColor.brown),
                                       .shadowOffset(CGSize(width: 10, height: 20)),
                                       .highlightedTextColor(UIColor.clear),
                                       .attributedText([
                                        [NSFontAttributeName: UIFont(name: "Helvetica", size: 16)!, NSForegroundColorAttributeName: UIColor.red],
                                        [kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!, NSForegroundColorAttributeName: UIColor.darkText],
                                        [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGray]
                                        ]),
                                       .text("Default Text"),
                                       .borderStyle(.bezel),
                                       .defaultTextAttributes([:]),
                                       .placeholder("place holder"),
                                       .clearsOnBeginEditing(false),
                                       .background(image),
                                       .disabledBackground(image),
                                       .typingAttributes([:]),
                                       .clearButtonMode(.always),
                                       .buttonTitle("Close", .normal),
                                       .buttonTitleColor(UIColor.yellow, .normal),
                                       .buttonTitleShadowColor(UIColor.brown, .highlighted),
                                       .buttonImage(image, .disabled),
                                       .buttonBackgroundImage(image, .application),
                                       .buttonAttributedTitle([[:]], UIControlState.normal),
                                       .contentEdgeInsets(UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)),
                                       .titleEdgeInsets(UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)),
                                       .reversesTitleShadowWhenHighlighted(false),
                                       .imageEdgeInsets(UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)),
                                       .adjustsImageWhenHighlighted(true),
                                       .adjustsImageWhenDisabled(false),
                                       .showsTouchWhenHighlighted(true),
                                       .ratio(1.5),
                                       .scrollEnabled(true),
                                       .contentOffset(CGPoint(x: 10, y: 15)),
                                       .contentSize(CGSize(width: 3, height: 5)),
                                       .contentInset(UIEdgeInsets(top: 4, left: 3, bottom: 2, right: 1)),
                                       .directionalLockEnabled(false),
                                       .bounces(true),
                                       .alwaysBounceVertical(true),
                                       .alwaysBounceHorizontal(true),
                                       .pagingEnabled(false),
                                       .showsHorizontalScrollIndicator(true),
                                       .showsVerticalScrollIndicator(true),
                                       .scrollIndicatorInsets(UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)),
                                       .indicatorStyle(.black),
                                       .decelerationRate(3.0),
                                       .delaysContentTouches(true),
                                       .canCancelContentTouches(false),
                                       .minimumZoomScale(0.4),
                                       .maximumZoomScale(0.8),
                                       .zoomScale(10),
                                       .bouncesZoom(true),
                                       .scrollsToTop(true),
                                       .keyboardDismissMode(.onDrag)]

            it("should convert a JSONDictionary to an Appearance instance correctly.") {

                do {
                    // Given
                    let path = Bundle(for: self.dynamicType).path(forResource: "appearances", ofType: "json")!
                    let mockJson = try JSONSerialization.jsonObject(with: NSData(contentsOfFile: path)! as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSONDictionary

                    // When
                    let appearances = Appearance.appearancesWithJSON(mockJson!)
                    let json = Appearance.JSONWithAppearances(appearances)

                    // Then
                    expect(appearances.count) == 85
                    expect(NSDictionary(dictionary: json)) == mockJson

                } catch {
                    fail("\(error)")
                }
            }

            it("should convert an Appearance instance to JSON correctly.") {
                do {
                    // Given
                    let path = Bundle(for: self.dynamicType).path(forResource: "appearances", ofType: "json")!
                    let mockJson = try JSONSerialization.jsonObject(with: NSData(contentsOfFile: path)! as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! JSONDictionary

                    // When
                    let json = Appearance.JSONWithAppearances(style)

                    // Then
                    expect(json.values.count) == 85
                    expect(NSDictionary(dictionary: json)) == mockJson
                } catch {
                    fail("\(error)")
                }
            }
        }

        describe("Layout is convertible") {
            it("should convert a JSONDictionary to an Layout instance correctly.") {
                do {
                    // Given
                    let mockLayout = Layout(["H:|-left-[title]-spaceH-[image]-right", "V:|-top-[title]-(>=bottom)|", "V:|-top-[image]-(>=bottom)|"],
                                            options: .alignAllCenterX,
                                            metrics: LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom_metrics": 13]))

                    let path = Bundle(for: self.dynamicType).path(forResource: "layout", ofType: "json")!
                    let json = try JSONSerialization.jsonObject(with: NSData(contentsOfFile: path)! as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSONDictionary

                    // When
                    let layout = Layout(rawValue: json!)

                    // Then
                    expect(layout) == mockLayout
                } catch {
                    fail("\(error)")
                }
            }

            it("should convert an Layout instance to JSON correctly.") {

                // Given
                let layout = Layout(["H:|-left-[title]-spaceH-[image]-right", "V:|-top-[title]-(>=bottom)|", "V:|-top-[image]-(>=bottom)|"],
                                    options: .alignAllCenterX,
                                    metrics: LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom_metrics": 13]))

                do {
                    let path = Bundle(for: self.dynamicType).path(forResource: "layout", ofType: "json")!
                    let mockJson = try JSONSerialization.jsonObject(with: NSData(contentsOfFile: path)! as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! JSONDictionary

                    // When
                    let json = layout.encode()

                    // Then
                    expect(NSDictionary(dictionary: json)) == mockJson
                } catch {
                    fail("\(error)")
                }
            }
        }

        describe("Brick is convertible") {
            it("should convert a JSONDictionary to an Brick instance correctly.") {
                do {
                    // Given

                    let path = Bundle(for: self.dynamicType).path(forResource: "brick", ofType: "json")!
                    let json = try JSONSerialization.jsonObject(with: NSData(contentsOfFile: path)! as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSONDictionary

                    // When
                    let brick = try Brick(rawValue: json!)

                    // Then
                    let mockBrick = BrickBuilder.article.brick().height(60).LGOutlet("button")
                    expect(brick.name) == mockBrick.name
                    expect(brick.layout) == mockBrick.layout
                    expect(brick.width ?? 0) == mockBrick.width ?? 0
                    expect(brick.height ?? 0) == mockBrick.height ?? 0
                } catch {
                    fail("\(error)")
                }
            }

            it("should convert an Brick instance to JSON correctly.") {

                // Given
                let brick = BrickBuilder.article.brick().height(60).LGOutlet("button")

                // When
                let json = brick.encode()

                do {
                    let path = Bundle(for: self.dynamicType).path(forResource: "brick", ofType: "json")!
                    let mockJson = try JSONSerialization.jsonObject(with: NSData(contentsOfFile: path)! as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! JSONDictionary

                    // Then
                    expect(NSDictionary(dictionary: json)) == mockJson
                } catch {
                    fail("\(error)")
                }
            }
        }

        it("is convertible with NSLayoutFormatOptions") {
            // Given
            let rawOptions = ["AlignAllLeft", "AlignAllRight", "AlignAllTop", "AlignAllBottom", "AlignAllLeading", "AlignAllTrailing", "AlignAllCenterX", "AlignAllCenterY", "AlignAllLastBaseline", "AlignAllFirstBaseline", "AlignmentMask", "DirectionLeadingToTrailing", "DirectionLeftToRight", "DirectionRightToLeft", "DirectionMask"]
            let options: NSLayoutFormatOptions = [.alignAllLeft, .alignAllRight, .alignAllTop, .alignAllBottom, .alignAllLeading, .alignAllTrailing, .alignAllCenterX, .alignAllCenterY, .alignAllLastBaseline, .alignAllFirstBaseline, .alignmentMask, .directionLeadingToTrailing, .directionLeftToRight, .directionRightToLeft, .directionMask]

            // When
            let convertedOptions = NSLayoutFormatOptions(rawValue: rawOptions)
            let encodedOptions = convertedOptions.encode()

            // Then
            expect(convertedOptions) == options
            expect(encodedOptions) == rawOptions
        }

        it("is convertible with UIControlState") {
            // Given
            let rawValues = ["Normal", "Highlighted", "Disabled", "Selected", "Application", "Reserved"]
            let values: UIControlState = [.normal, .highlighted, .disabled, .selected, .application, .reserved]

            // When
            let convertedValues = UIControlState(rawValue: rawValues)
            let encodedValues = convertedValues.encode()

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with UIDataDetectorTypes") {
            // Given
            let rawValues = ["PhoneNumber", "Link", "Address", "CalendarEvent", "None", "All"]
            let values: UIDataDetectorTypes = [.phoneNumber, .link, .address, .calendarEvent, [], .all]

            // When
            let convertedValues = UIDataDetectorTypes(rawValue: rawValues)
            let encodedValues = convertedValues.encode()

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }


        it("is convertible with UIScrollViewKeyboardDismissMode") {
            // Given
            let rawValues = ["None", "OnDrag", "Interactive"]
            let values: [UIScrollViewKeyboardDismissMode] = [.none, .onDrag, .interactive]

            // When
            let convertedValues = rawValues.map({ (value) -> UIScrollViewKeyboardDismissMode in
                UIScrollViewKeyboardDismissMode(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with UIScrollViewIndicatorStyle") {
            // Given
            let rawValues = ["Default", "Black", "White"]
            let values: [UIScrollViewIndicatorStyle] = [.default, .black, .white]

            // When
            let convertedValues = rawValues.map({ (value) -> UIScrollViewIndicatorStyle in
                UIScrollViewIndicatorStyle(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with UITextFieldViewMode") {
            // Given
            let rawValues = ["Never", "WhileEditing", "UnlessEditing", "Always"]
            let values: [UITextFieldViewMode] = [.never, .whileEditing, .unlessEditing, .always]

            // When
            let convertedValues = rawValues.map({ (value) -> UITextFieldViewMode in
                UITextFieldViewMode(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with UIBaselineAdjustment") {
            // Given
            let rawValues = ["AlignBaselines", "AlignCenters", "None"]
            let values: [UIBaselineAdjustment] = [.alignBaselines, .alignCenters, .none]

            // When
            let convertedValues = rawValues.map({ (value) -> UIBaselineAdjustment in
                UIBaselineAdjustment(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with UITextBorderStyle") {
            // Given
            let rawValues = ["None", "Line", "Bezel", "RoundedRect"]
            let values: [UITextBorderStyle] = [.none, .line, .bezel, .roundedRect]

            // When
            let convertedValues = rawValues.map({ (value) -> UITextBorderStyle in
                UITextBorderStyle(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with NSLineBreakMode") {
            // Given
            let rawValues = ["ByWordWrapping", "ByCharWrapping", "ByClipping", "ByTruncatingHead", "ByTruncatingTail", "ByTruncatingMiddle"]
            let values: [NSLineBreakMode] = [.byWordWrapping, .byCharWrapping, .byClipping, .byTruncatingHead, .byTruncatingTail, .byTruncatingMiddle]

            // When
            let convertedValues = rawValues.map({ (value) -> NSLineBreakMode in
                NSLineBreakMode(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with NSTextAlignment") {
            // Given
            let rawValues = ["Left", "Center", "Right", "Justified", "Natural"]
            let values: [NSTextAlignment] = [.left, .center, .right, .justified, .natural]

            // When
            let convertedValues = rawValues.map({ (value) -> NSTextAlignment in
                NSTextAlignment(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with UIViewContentMode") {
            // Given
            let rawValues = ["ScaleToFill", "ScaleAspectFit", "ScaleAspectFill", "Redraw", "Center", "Top", "Bottom", "Left", "Right", "TopLeft", "TopRight", "BottomLeft", "BottomRight"]
            let values: [UIViewContentMode] = [.scaleToFill, .scaleAspectFit, .scaleAspectFill, .redraw, .center, .top, .bottom, .left, .right, .topLeft, .topRight, .bottomLeft, .bottomRight]

            // When
            let convertedValues = rawValues.map({ (value) -> UIViewContentMode in
                UIViewContentMode(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with UIViewTintAdjustmentMode") {
            // Given
            let rawValues = ["Automatic", "Normal", "Dimmed"]
            let values: [UIViewTintAdjustmentMode] = [.automatic, .normal, .dimmed]

            // When
            let convertedValues = rawValues.map({ (value) -> UIViewTintAdjustmentMode in
                UIViewTintAdjustmentMode(rawValue: value)
            })
            let encodedValues = convertedValues.map({ (value) -> String in
                value.encode()
            })

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == rawValues
        }

        it("is convertible with NSRange") {
            // Given
            let rawValues = [2, 10]
            let values: NSRange = NSRange(location: 2, length: 10)

            // When
            let convertedValues = NSRange(rawValue: rawValues)
            let encodedValues = convertedValues.encode()

            // Then
            expect(NSEqualRanges(convertedValues, values)) == true
            expect(encodedValues) == rawValues

            expect(NSEqualRanges(NSRange(rawValue: [2, 10, 10]), NSRange(location: 0, length: 0))) == true
        }

        it("is convertible with CGSize") {
            // Given
            let rawValues: [CGFloat] = [10, 10]
            let values = CGSize(width: 10, height: 10)

            // When
            let convertedValues = CGSize(rawValue: rawValues)
            let encodedValues = convertedValues.encode()

            // Then
            expect(convertedValues.equalTo(values)) == true
            expect(encodedValues) == rawValues

            expect(CGSize(rawValue: [2, 10, 10]).equalTo(CGSize.zero)) == true
        }

        it("is convertible with CGPoint") {
            // Given
            let rawValues: [CGFloat] = [2, 10]
            let values = CGPoint(x: 2, y: 10)

            // When
            let convertedValues = CGPoint(rawValue: rawValues)
            let encodedValues = convertedValues.encode()

            // Then
            expect(convertedValues.equalTo(values)) == true
            expect(encodedValues) == rawValues

            expect(CGPoint(rawValue: [2, 10, 10]).equalTo(CGPoint.zero)) == true
        }

        it("is convertible with UIEdgeInsets") {
            // Given
            let rawValues: [CGFloat] = [2, 10, 2, 10]
            let values = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)

            // When
            let convertedValues = UIEdgeInsets(rawValue: rawValues)
            let encodedValues = convertedValues.encode()

            // Then
            expect(UIEdgeInsetsEqualToEdgeInsets(convertedValues, values)) == true
            expect(encodedValues) == rawValues

            expect(UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsets(rawValue: [2, 10, 10]), UIEdgeInsets.zero)) == true
        }

        it("is convertible with NSURL") {
            // Given
            let rawValues: JSONDictionary = ["url": "www.apple.com"]
            let values = NSURL(string: "www.apple.com")

            // When
            let convertedValues = URL(rawValue: rawValues)!
            let encodedValues = convertedValues.lg_encode()

            // Then
            expect(convertedValues) == values
            expect(NSDictionary(dictionary: encodedValues)) == rawValues
        }

        it("is convertible with UIColor") {
            // Given
            let rawValues = "#0000FF"
            let values = UIColor.blue

            // When
            let convertedValues = UIColor(rawValue: rawValues)
            let encodedValues = convertedValues.lg_encode()

            // Then
            expect(convertedValues) == values
            expect(encodedValues) == "#0000FF"
        }

        it("is convertible with UIImage") {
            // Given
            let values = UIImage(named: "twitter_favorite", in: Bundle(for: self.dynamicType), compatibleWith: nil)!

            // When
            // let convertedValues: UIImage? = UIImage(json: nil)
            let encodedValues = values.lg_encode()!

            // Then
            // expect(convertedValues) == nil
            expect((encodedValues["data"] as! String).hasPrefix("iVBORw0KGgoAAAANSUhEUgAAABsAAAAaCAYAAABGiCfwAAAAAXNSR0IArs4c6QAA")) == true
        }
    }
}
