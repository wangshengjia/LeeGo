

import XCTest
import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class BrickSpec: QuickSpec {
    override func spec() {

        describe("Brick tests") {

            it("should create a new component target instance correctly") {
                // Given
                let component = Brick(name: "title", targetClass: UILabel.self).width(40).height(60).style([.backgroundColor(UIColor.greenColor())])

                // Then
                expect(component.name) == "title"
                expect(component.targetClass) === UILabel.self
                expect(component.width) == 40
                expect(component.height) == 60
                expect(component.hashValue) == "title".hashValue
                if case let .backgroundColor(color) = component.style.first! {
                    expect(color) == UIColor.greenColor()
                }
            }

            it("should create a new component with subcomponents", closure: { () -> () in
                // Given
                let mockLayout = Layout()

                // When
                let component = Brick(name: "header", targetClass: UIView.self).components(Brick(name: "title", targetClass: UILabel.self), layout: { (title) -> Layout in
                    expect(title) == "title"
                    return mockLayout
                })

                // Then
                expect(component.components?.count) == 1
                expect(component.components?.last?.name) == "title"
                expect(component.layout) == mockLayout
            })

            it("should create a new component with subcomponents", closure: { () -> () in

                // Given
                let mockLayout = Layout()

                // When
                let component = Brick(name: "header", targetClass: UIView.self).components(Brick(name: "title", targetClass: UILabel.self), Brick(name: "avatar", targetClass: UIImageView.self), layout: { (title, avatar) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    return mockLayout
                })

                // Then
                expect(component.components?.count) == 2
                expect(component.components?.last?.name) == "avatar"
                expect(component.layout) == mockLayout
            })

            it("should create a new component with subcomponents", closure: { () -> () in
                // Given
                let mockLayout = Layout()

                // When
                let component = Brick(name: "header", targetClass: UIView.self).components(TestData.title1, TestData.avatar1, TestData.view, layout: { (title, avatar, view) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    expect(view) == "view"
                    return mockLayout
                })

                // Then
                expect(component.components?.count) == 3
                expect(component.components?.last?.name) == "view"
                expect(component.layout) == mockLayout
            })

            it("should create a new component with subcomponents", closure: { () -> () in

                // Given
                let mockLayout = Layout()

                // When
                let component = Brick(name: "header", targetClass: UIView.self).components(TestData.title1, TestData.avatar1, TestData.view, TestData.title3, layout: { (title, avatar, view, title3) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    expect(view) == "view"
                    expect(title3) == "title3"
                    return mockLayout
                })

                // Then
                expect(component.components?.count) == 4
                expect(component.components?.last?.name) == "title3"
                expect(component.layout) == mockLayout
            })

            it("should create a new component with subcomponents", closure: { () -> () in

                // Given
                let mockLayout = Layout()

                // When
                let component = Brick(name: "header", targetClass: UIView.self).components(TestData.title1, TestData.avatar1, TestData.view, TestData.title3, TestData.header2, layout: { (title, avatar, view, title3, header2) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    expect(view) == "view"
                    expect(title3) == "title3"
                    expect(header2) == "header2"
                    return mockLayout
                })

                // Then
                expect(component.components?.count) == 5
                expect(component.components?.last?.name) == "header2"
                expect(component.layout) == mockLayout
            })

            it("should create a new component with subcomponents", closure: { () -> () in
                // Given
                let mockLayout = Layout()

                // When
                let component = Brick(name: "header", targetClass: UIView.self).components([TestData.title1, TestData.avatar1], layout: mockLayout)

                // Then
                expect(component.components?.count) == 2
                expect(component.components?.last?.name) == "avatar"
                expect(component.layout) == mockLayout
            })

            it("should build component target instance", closure: { () -> () in
                // Given
                let component = ComponentBuilder.header.build()

                // Then
                expect(component.name) == "header"
                expect(component.targetClass) === UIView.self
            })

            it("should build component target instance from nib", closure: { () -> () in

                // Given
                let component = ComponentBuilder.title.buildFromNib(UILabel.self, nibName: "nibname")

                // Then
                expect(component.name) == "title"
                expect(component.targetClass) === UILabel.self
                expect(component.nibName) == "nibname"
            })

            it("should build component with cell height resolver", closure: { () -> () in

                // Given
                let component = ComponentBuilder.header.build().heightResolver { _, childrenHeights, _ in
                    return childrenHeights[0] + childrenHeights[1]
                }

                // Then
                expect(component.name) == "header"
                expect(component.targetClass) === UIView.self
                expect(component.heightResolver!(fittingWidth:0, childrenHeights: [10, 20], metrics: LayoutMetrics())) == 30
            })

            it("builder & target should be equals") {
                XCTAssertTrue(ComponentBuilder.header == Brick(name: "header"))
                XCTAssertTrue(Brick(name: "header") == ComponentBuilder.header)
            }
        }
    }
}














