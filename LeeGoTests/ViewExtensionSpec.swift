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
                expect(view.componentName) == "article"
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
                expect(view.componentName) == "header"
                expect(view.isRoot) == true
                expect(view.configuration) == TestData.header1
                expect(view.configuration!.layout!.formats) == ["H:|-left-[title]-(>=right)-|", "H:|-left-[avatar]-(>=right)-|", "V:|-top-[title]-interspaceV-[avatar]-bottom-|"]
                expect(view.backgroundColor) == UIColor.redColor()
                expect(view.subviews.count) == 2
                expect((view.subviews[0] as! UILabel).configuration) == TestData.title1
                expect((view.subviews[0] as! UILabel).componentName) == "title"
                expect((view.subviews[0] as! UILabel).font) == UIFont(name: "Helvetica", size: 18)
                expect((view.subviews[1] as! UIImageView).configuration) == TestData.avatar1
                expect((view.subviews[1] as! UIImageView).componentName) == "avatar"
            }

            it("should re-configure a component correctly with .WhenComponentChanged strategy -> component changed") {
                // Given
                let cell = UITableViewCell()
                cell.configure(TestData.header1)
                cell.configure(TestData.header2, updatingStrategy: .Always)

                // When
                cell.configure(TestData.header3)

                // Then
                expect(cell.contentView.configuration) != nil
                expect(cell.contentView.componentName) == "header3"
                expect(cell.contentView.isRoot) == true
                expect(cell.contentView.configuration) == TestData.header3
                expect(cell.contentView.configuration!.layout!.formats) == ["H:|[title3]|", "V:|[view]|"]
                expect(cell.contentView.subviews.count) == 2
                expect((cell.contentView.subviews[1] as! UILabel).configuration) == TestData.title3
                expect((cell.contentView.subviews[1] as! UILabel).componentName) == "title3"
                expect((cell.contentView.subviews[1] as! UILabel).font) == UIFont(name: "Arial", size: 14)
                expect((cell.contentView.subviews[0] as UIView).configuration) == TestData.view
                expect((cell.contentView.subviews[0] as UIView).componentName) == "view"
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
                expect(view.componentName) == "header"
                expect(view.isRoot) == true
                expect(view.configuration) == emptyHeader
                expect(view.backgroundColor) == UIColor.redColor()
                expect(view.subviews.count) == 2
                expect((view.subviews[0] as! UILabel).configuration) == TestData.title1
                expect((view.subviews[0] as! UILabel).componentName) == "title"
                expect((view.subviews[0] as! UILabel).font) == UIFont(name: "Avenir", size: 12)
                expect((view.subviews[1] as! UIImageView).configuration) == TestData.avatar1
                expect((view.subviews[1] as! UIImageView).componentName) == "avatar"
            }

            it("should re-configure a component correctly with .Always strategy.") {
                // Given
                let cell = UICollectionViewCell()
                cell.configure(TestData.header1)

                // When
                cell.configure(TestData.header2, updatingStrategy: .Always)

                // Then
                expect(cell.contentView.configuration) != nil
                expect(cell.contentView.configuration) == TestData.header2
                expect(cell.contentView.componentName) == "header2"
                expect(cell.contentView.configuration!.layout!.formats) == ["H:|-left-[title]-interspaceH-[avatar]-interspaceH-[view]-(>=right)-|", "V:|-top-[title]-(>=bottom)-|", "V:|-top-[avatar]-(>=bottom)-|", "V:|-top-[view]-(>=bottom)-|"]
                expect(cell.contentView.backgroundColor).to(beNil())
                expect(cell.contentView.subviews.count) == 3
                expect((cell.contentView.subviews[0] as! UILabel).configuration) == TestData.title2
                expect((cell.contentView.subviews[0] as! UILabel).componentName) == "title"
                expect((cell.contentView.subviews[0] as! UILabel).font) == UIFont(name: "Avenir", size: 12)
                expect((cell.contentView.subviews[1] as! UIImageView).configuration) == TestData.avatar2
                expect((cell.contentView.subviews[1] as! UIImageView).componentName) == "avatar"
                expect((cell.contentView.subviews[1] as! UIImageView).backgroundColor) == UIColor.greenColor()
                expect((cell.contentView.subviews[2] as UIView).configuration) == TestData.view
                expect((cell.contentView.subviews[2] as UIView).componentName) == "view"
            }

            it("cell should have dynamic fitting height correctly") {
                // Given
                let cell = UICollectionViewCell()
                cell.configure(TestData.header1)

                // When
                let attributes = cell.preferredLayoutAttributesFittingAttributes(UICollectionViewLayoutAttributes())

                // Then
                expect(attributes.frame.height) == 71
            }

            it("cell should have dynamic fitting height correctly") {
                // Given
                let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
                cell.configure(TestData.header2)

                // When
                let attributes = cell.preferredLayoutAttributesFittingAttributes(UICollectionViewLayoutAttributes())

                // Then
                expect(attributes.frame.height) == 130
            }
        }
    }
}

