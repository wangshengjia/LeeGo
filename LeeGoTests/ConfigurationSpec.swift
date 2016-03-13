//
//  ConfigurationSpecs.swift
//  LeeGo
//
//  Created by Victor WANG on 20/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class ConfigurationSpec: QuickSpec {
    override func spec() {

        describe("Layout Metrics tests") {
            it("should create a metrics instance correctly") {
                let metrics = LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom": 17])

                expect(metrics.top) == 20
                expect(metrics.left) == 20
                expect(metrics.bottom) == 20
                expect(metrics.right) == 20
                expect(metrics.spaceH) == 10
                expect(metrics.spaceV) == 10
                expect(metrics.customMetrics) == ["custom": 17]
            }

            it("should return metrics correctly") {
                let metrics = LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom": 17])

                let result = metrics.metrics()

                expect(result) == ["top": 20, "left": 20, "bottom": 20, "right": 20, "spaceH": 10, "spaceV": 10, "custom": 17]
            }

            it("should compare two metrics instances correctly") {
                let metrics1 = LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom": 17])
                let metrics2 = LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom": 17])
                let metrics3 = LayoutMetrics(top: 20, left: 20, bottom: 20, right: 20, spaceH: 10, spaceV: 10, customMetrics: ["custom": 18])

                expect(metrics1) == metrics2
                expect(metrics2) != metrics3
            }
        }


        describe("Layout tests") {
            it("should create an empty layout") {
                let layout = Layout()
                expect(layout.formats) == []
            }

            it("should create layout with formats") {
                let mockFormat = ["format1", "format2"]
                let layout = Layout(mockFormat)

                expect(layout.formats) == mockFormat
                expect(layout.formats) != ["format2", "format2"]
            }

            it("should compare two layout instances correctly") {
                let layout1 = Layout(["format1", "format2"], options: NSLayoutFormatOptions.AlignAllBottom, metrics: LayoutMetrics(20, 20, 20, 20 ,10 ,10))
                let layout2 = Layout(["format1", "format2"], options: NSLayoutFormatOptions.AlignAllBottom, metrics: LayoutMetrics(20, 20, 20, 20 ,10 ,10))
                expect(layout1) == layout2
            }
        }

        describe("Appearacne tests") {
            it("should convert Appearance to String `none`") {
                expect(Appearance.none.toString()) == "none"
            }

            it("should apply appearances correctly to given UIView") {
                // Given
                let view = UIView()
                let appearances: [Appearance] = [
                    .backgroundColor(UIColor.greenColor()),
                    .translatesAutoresizingMaskIntoConstraints(false)
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: view)
                }

                // Then
                expect(view.backgroundColor) == UIColor.greenColor()
                expect(view.translatesAutoresizingMaskIntoConstraints) == false
            }

            it("should apply appearance correctly to given UILabel") {
                // Given
                let label = UILabel()
                let appearances: [Appearance] = [
                    .font(UIFont(name: "Helvetica", size: 16)!),
                    .textColor(UIColor.greenColor()),
                    .textAlignment(.Center),
                    .numberOfLines(3),
                    .defaultLabelText("labelText"),
                ]

                // When
                for appearance in appearances {
                    appearance.apply(to: label)
                }

                // Then
                expect(label.font) == UIFont(name: "Helvetica", size: 16)
                expect(label.textColor) == UIColor.greenColor()
                expect(label.textAlignment) == NSTextAlignment.Center
                expect(label.numberOfLines) == 3
                expect(label.text) == "labelText"

                Appearance.attributedText([[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]).apply(to: label)
                expect(label.attributedText) == NSAttributedString(string: " ", attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!])
            }

            it("should apply appearance correctly to given UIButton") {
                // Given
                let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                let button = UIButton()
                let appearances: [Appearance] = [
                    .buttonTitle("button", .Normal),
                    .buttonTitleColor(UIColor.redColor(), .Normal),
                    .buttonTitleShadowColor(UIColor.grayColor(), .Highlighted),
//                    .buttonImage(UIImage(named: "lego")!, .Highlighted),
//                    .buttonBackgroundImage(UIImage(named: "lego")!, .Normal),
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
            }
        }
    }
}
