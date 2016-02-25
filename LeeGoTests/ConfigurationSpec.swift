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

        describe("Layout tests") {
            it("should create a empty layout") {
                let layout = Layout()
                expect(layout.formats) == []
            }
            it("should create layout with formats") {
                let mockFormat = ["format1", "format2"]
                let layout = Layout(mockFormat)

                expect(layout.formats) == mockFormat
                expect(layout.formats) != ["format2", "format2"]

                expect(layout.metrics!["top"]!.isEqual(0))
                expect(layout.metrics!["left"]!.isEqual(0))
                expect(layout.metrics!["bottom"]!.isEqual(0))
                expect(layout.metrics!["right"]!.isEqual(0))
                expect(layout.metrics!["interspaceH"]!.isEqual(0))
                expect(layout.metrics!["interspaceV"]!.isEqual(0))
            }

            it("should create layout with formats") {
                let layout = Layout([], ["metrics": 10 ])

                expect(layout.metrics!["metrics"]!.isEqual(10))
            }

            it("two layout should be ==") {
                expect(Layout()) == Layout()

                let layout1 = Layout(["format1", "format2"], ["top": 22, "left": 0, "bottom": 0, "right" : 22, "interspaceH": 0, "interspaceV": 0])
                let layout2 = Layout(["format1", "format2"], (22, 0, 0, 22, 0, 0))
                
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

                Appearance.attributedString([[NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]]).apply(to: label)
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
