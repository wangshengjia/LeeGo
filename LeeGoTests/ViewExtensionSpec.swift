//
//  ViewExtensionSpec.swift
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

class ViewExtensionSpec: QuickSpec {
    override func spec() {
        describe("View extensions") {
            it("should configure an empty component correctly.") {
                // Given
                let view = UIView()
                expect(view.configuration).to(beNil())

                // When
                view.configure(ComponentTarget(name: "article"))

                // Then
                expect(view.configuration) != nil
                expect(view.name) == "article"
                expect(view.isRoot) == true
            }

            it("should configure a component correctly.") {
                // Given
                let view = UIView()

                // When
                view.configure(TestData.header1)

                // Then
                expect(view.configuration) != nil
                XCTAssertTrue(view.dynamicType == UIView.self)
                expect(view.name) == "header"
                expect(view.isRoot) == true
                expect(view.configuration) == TestData.header1
                expect(view.configuration!.layout!.formats) == ["H:|[title][avatar]|"]
                expect(view.backgroundColor) == UIColor.redColor()
                expect(view.subviews.count) == 2
                expect((view.subviews[0] as! UILabel).configuration) == TestData.title1
                expect((view.subviews[0] as! UILabel).name) == "title"
                expect((view.subviews[0] as! UILabel).font) == UIFont(name: "Helvetica", size: 18)
                expect((view.subviews[1] as! UIImageView).configuration) == TestData.avatar1
                expect((view.subviews[1] as! UIImageView).name) == "avatar"
            }

            it("should re-configure a component correctly with .WhenComponentChanged strategy -> component changed") {
                // Given
                let view = UIView()
                view.configure(TestData.header1)
                view.configure(TestData.header2, updatingStrategy: .Always)

                // When
                view.configure(TestData.header3)

                // Then
                expect(view.configuration) != nil
                XCTAssertTrue(view.dynamicType == UIView.self)
                expect(view.name) == "header3"
                expect(view.isRoot) == true
                expect(view.configuration) == TestData.header3
                expect(view.configuration!.layout!.formats) == ["H:|[title3]|", "V:|[view]|"]
                expect(view.subviews.count) == 2
                expect((view.subviews[1] as! UILabel).configuration) == TestData.title3
                expect((view.subviews[1] as! UILabel).name) == "title3"
                expect((view.subviews[1] as! UILabel).font) == UIFont(name: "Arial", size: 14)
                expect((view.subviews[0] as UIView).configuration) == TestData.view
                expect((view.subviews[0] as UIView).name) == "view"
            }

            it("should re-configure a component correctly with .WhenComponentChanged strategy -> component did not change") {
                // TODO: Is that what we want ?

                // Given
                let view = UIView()
                view.configure(TestData.header1)
                view.configure(TestData.header2, updatingStrategy: .Always)
                view.configure(TestData.header1)

                // When
                let emptyHeader = ComponentBuilder.header.build()
                view.configure(emptyHeader)

                // Then
                expect(view.configuration) != nil
                XCTAssertTrue(view.dynamicType == UIView.self)
                expect(view.name) == "header"
                expect(view.isRoot) == true
                expect(view.configuration) == emptyHeader
                expect(view.backgroundColor) == UIColor.redColor()
                expect(view.subviews.count) == 2
                expect((view.subviews[0] as! UILabel).configuration) == TestData.title1
                expect((view.subviews[0] as! UILabel).name) == "title"
                expect((view.subviews[0] as! UILabel).font) == UIFont(name: "Avenir", size: 12)
                expect((view.subviews[1] as! UIImageView).configuration) == TestData.avatar1
                expect((view.subviews[1] as! UIImageView).name) == "avatar"
            }

            it("should re-configure a component correctly with .Always strategy.") {
                // Given
                let view = UIView()
                view.configure(TestData.header1)

                // When
                view.configure(TestData.header2, updatingStrategy: .Always)

                // Then
                expect(view.configuration) != nil
                expect(view.configuration) == TestData.header2
                expect(view.name) == "header2"
                expect(view.configuration!.layout!.formats) == ["H:|[title][avatar]|", "V:|[view]|"]
                expect(view.backgroundColor).to(beNil())
                expect(view.subviews.count) == 3
                expect((view.subviews[0] as! UILabel).configuration) == TestData.title2
                expect((view.subviews[0] as! UILabel).name) == "title"
                expect((view.subviews[0] as! UILabel).font) == UIFont(name: "Avenir", size: 12)
                expect((view.subviews[1] as! UIImageView).configuration) == TestData.avatar2
                expect((view.subviews[1] as! UIImageView).name) == "avatar"
                expect((view.subviews[1] as! UIImageView).backgroundColor) == UIColor.greenColor()
                expect((view.subviews[2] as UIView).configuration) == TestData.view
                expect((view.subviews[2] as UIView).name) == "view"
            }
        }
    }
}

