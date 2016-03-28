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
            let image = UIImage(named: "twitter_favorite", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!

            let style: [Appearance] = [.userInteractionEnabled(true),
                                       .translatesAutoresizingMaskIntoConstraints(true),
                                       .backgroundColor(UIColor.blueColor()),
                                       .tintColor(UIColor.redColor()),
                                       .tintAdjustmentMode(.Dimmed),
                                       .cornerRadius(5),
                                       .borderWidth(1),
                                       .borderColor(UIColor.grayColor()),
                                       .multipleTouchEnabled(false),
                                       .exclusiveTouch(false),
                                       .clipsToBounds(true),
                                       .alpha(0.4),
                                       .opaque(true),
                                       .clearsContextBeforeDrawing(false),
                                       .hidden(true),
                                       .contentMode(.BottomLeft),
                                       .enabled(true),
                                       .selected(false),
                                       .highlighted(true),
                                       .font(UIFont.systemFontOfSize(10)),
                                       .textColor(UIColor.redColor()),
                                       .textAlignment(.Center),
                                       .numberOfLines(10),
                                       .lineBreakMode(.ByClipping),
                                       .selectedRange(NSRange(location:0, length: 4)),
                                       .editable(true),
                                       .selectable(true),
                                       .dataDetectorTypes(.Address),
                                       .allowsEditingTextAttributes(false),
                                       .clearsOnInsertion(true),
                                       .textContainerInset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 20)),
                                       .linkTextAttributes([
                                        NSFontAttributeName: UIFont.systemFontOfSize(13),
                                        NSForegroundColorAttributeName: UIColor.yellowColor(),
                                        NSBackgroundColorAttributeName: UIColor.blueColor()
                                        ]),
                                       .lineFragmentPadding(12),
                                       .minimumScaleFactor(0.3),
                                       .adjustsFontSizeToFitWidth(true),
                                       .baselineAdjustment(.AlignCenters),
                                       .shadowColor(UIColor.brownColor()),
                                       .shadowOffset(CGSize(width: 10, height: 20)),
                                       .highlightedTextColor(UIColor.clearColor()),
                                       .attributedText([
                                        [NSFontAttributeName: UIFont(name: "Helvetica", size: 16)!, NSForegroundColorAttributeName: UIColor.redColor()],
                                        [kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!, NSForegroundColorAttributeName: UIColor.darkTextColor()],
                                        [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                                        ]),
                                       .text("Default Text"),
                                       .borderStyle(.Bezel),
                                       .defaultTextAttributes([:]),
                                       .placeholder("place holder"),
                                       .attributedPlaceholder([[:]]),
                                       .clearsOnBeginEditing(false),
                                       .background(image),
                                       .disabledBackground(image),
                                       .typingAttributes([:]),
                                       .clearButtonMode(.Always),
                                       .buttonTitle("Close", .Normal),
                                       .buttonTitleColor(UIColor.yellowColor(), .Normal),
                                       .buttonTitleShadowColor(UIColor.brownColor(), .Highlighted),
                                       .buttonImage(image, .Disabled),
                                       .buttonBackgroundImage(image, .Application),
                                       .buttonAttributedTitle([[:]], UIControlState.Normal),
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
                                       .indicatorStyle(.Black),
                                       .decelerationRate(3.0),
                                       .delaysContentTouches(true),
                                       .canCancelContentTouches(false),
                                       .minimumZoomScale(0.4),
                                       .maximumZoomScale(0.8),
                                       .zoomScale(10),
                                       .bouncesZoom(true),
                                       .scrollsToTop(true),
                                       .keyboardDismissMode(.OnDrag)]

            it("should convert a JSONDictionary to an Appearance instance correctly.") {

                do {
                    // Given
                    let path = NSBundle(forClass: self.dynamicType).pathForResource("appearances", ofType: "json")!
                    let mockJson = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions(rawValue: 0)) as? JSONDictionary

                    // When
                    let appearances = Appearance.appearancesWithJSON(mockJson!)
                    let json = Appearance.JSONWithAppearances(appearances)

                    // Then
                    expect(appearances.count) == 86
                    expect(NSDictionary(dictionary: json)) == mockJson

                } catch {
                    fail("\(error)")
                }
            }

            it("should convert an Appearance instance to JSON correctly.") {
                do {
                    // Given
                    let path = NSBundle(forClass: self.dynamicType).pathForResource("appearances", ofType: "json")!
                    let mockJson = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions(rawValue: 0)) as! JSONDictionary

                    // When
                    let json = Appearance.JSONWithAppearances(style)

                    // Then
                    expect(json.values.count) == 86
                    expect(NSDictionary(dictionary: json)) == mockJson

                    //                    let data = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
                    //                    let jsonStr = String(data: data, encoding: NSUTF8StringEncoding)!
                    //                    print(jsonStr)
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
                                            options: .AlignAllCenterX,
                                            metrics: LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom_metrics": 13]))

                    let path = NSBundle(forClass: self.dynamicType).pathForResource("layout", ofType: "json")!
                    let json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions(rawValue: 0)) as? JSONDictionary

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
                                    options: .AlignAllCenterX,
                                    metrics: LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom_metrics": 13]))

                do {
                    let path = NSBundle(forClass: self.dynamicType).pathForResource("layout", ofType: "json")!
                    let mockJson = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions(rawValue: 0)) as! JSONDictionary

                    // When
                    let json = layout.encode()

                    // Then
                    expect(NSDictionary(dictionary: json)) == mockJson
                } catch {
                    fail("\(error)")
                }
            }
        }

        describe("ComponentTarget is convertible") {
            it("should convert a JSONDictionary to an ComponentTarget instance correctly.") {
                do {
                    // Given
                    let mockComponent = ComponentBuilder.article.componentTarget()

                    let path = NSBundle(forClass: self.dynamicType).pathForResource("component", ofType: "json")!
                    let json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions(rawValue: 0)) as? JSONDictionary

                    // When
                    let component = try ComponentTarget(rawValue: json!)

                    // Then
                    expect(component.name) == mockComponent.name
                    expect(component.layout) == mockComponent.layout
                    expect(component.width ?? 0) == mockComponent.width ?? 0
                    expect(component.height ?? 0) == mockComponent.height ?? 0
                } catch {
                    fail("\(error)")
                }
            }

            it("should convert an ComponentTarget instance to JSON correctly.") {

                // Given
                let component = ComponentBuilder.article.componentTarget()

                // When
                let json = component.encode()

                // Then
                do {
                    let path = NSBundle(forClass: self.dynamicType).pathForResource("component", ofType: "json")!
                    let mockJson = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions(rawValue: 0)) as! JSONDictionary

                    // Then
                    expect(NSDictionary(dictionary: json)) == mockJson
                } catch {
                    fail("\(error)")
                }
            }
        }
    }
}