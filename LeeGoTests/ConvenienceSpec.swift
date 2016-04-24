//
//  ConvenienceSpec.swift
//  LeeGo
//
//  Created by Victor WANG on 20/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class ConvenienceSpec: QuickSpec {

    private enum JSONKey: JSONKeyType {
        case targetClass
    }

    override func spec() {
        describe("Convenience methods") {
            // Given
            let path = NSBundle(forClass: self.dynamicType).pathForResource("brick", ofType: "json")!
            let json = (try? NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions(rawValue: 0)) as! JSONDictionary)!
            
            context("when parse value from JSON like structure") {
                it("should get value with a String key correctly.") {

                    // When
                    do {
                        let _: [JSONDictionary] = try json.parse("bricks")
                    } catch {
                        fail("should not fail")
                    }

                    // Then
                    expect{ try json.parse("bricks1") }.to(throwError())
                    expect{
                        let _: String = try json.parse("bricks")
                        return ""
                        }.to(throwError())

                    let targetClass: String = json.parse(JSONKey.targetClass, "")
                    expect(targetClass) == "UIView"

                    let width: CGFloat = json.parse("width1", 10.0)
                    expect(width) == 10.0
                    
                    let name: String = json.parse("name", "unknown")
                    expect(name) == "article"
                }
            }

            let attributes: [Attributes] = [
                [NSFontAttributeName: UIFont(name: "Helvetica", size: 16)!, NSForegroundColorAttributeName: UIColor.redColor()],
                [kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor.darkTextColor()],
                [NSFontAttributeName: UIFont(name: "Avenir", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
            ]

            it("should set attributed string correctly") {
                // Given
                let label = UILabel()
                let textField = UITextField()
                let textView = UITextView()
                let button = UIButton()

                // When
                label.setAttributedString(with: attributes)
                textField.setAttributedString(with: attributes)
                textView.setAttributedString(with: attributes)
                button.setAttributedButtonTitle(with: attributes, state: .Normal)

                // Then
                expect(label.attributedText).notTo(beNil())
                expect(textField.attributedText).notTo(beNil())
                expect(textView.attributedText).notTo(beNil())

                var range = NSRange(location: 1, length: 1)
                expect(NSDictionary(dictionary: (label.attributedText?.attributesAtIndex(0, effectiveRange: &range))!)) == attributes[1]
                for (attrKey, attrValue) in attributes[1] {
                    let containsAttr = NSDictionary(dictionary: (textField.attributedText?.attributesAtIndex(0, effectiveRange: &range))!).contains({ (key, value) -> Bool in
                        return attrKey == key as! String && attrValue.isEqual(value)
                    })
                    expect(containsAttr) == true
                }

                expect(NSDictionary(dictionary: (textView.attributedText?.attributesAtIndex(0, effectiveRange: &range))!)) == attributes[1]
                expect(NSDictionary(dictionary: (button.attributedTitleForState(.Normal)?.attributesAtIndex(0, effectiveRange: &range))!)) == attributes[1]
            }

            it("should update attributed string correctly") {
                // Given
                let label = UILabel()
                let textField = UITextField()
                let textView = UITextView()

                label.setAttributedString(with: attributes)
                textField.setAttributedString(with: attributes)
                textView.setAttributedString(with: attributes)

                // When
                label.attributedText = label.updatedAttributedString(with: ["First", "Second", "Third"])
                textField.attributedText = textField.updatedAttributedString(with: ["First1", "Second2", "Third3"])
                textView.attributedText = textView.updatedAttributedString(with: ["FirstA", "SecondB", "ThirdC"])

                // Then
                expect(label.attributedText?.string) == "FirstSecondThird"
                expect(textField.attributedText?.string) == "First1Second2Third3"
                expect(textView.attributedText?.string) == "FirstASecondBThirdC"
            }

            it("should formatted json to string correctly.") {
                // When
                let jsonStr = formattedStringFromJSON(json)

                // Then
                expect(jsonStr).notTo(beNil())
            }

        }
    }
}

