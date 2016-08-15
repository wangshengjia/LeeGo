

import XCTest
import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class BrickSpec: QuickSpec {
    override func spec() {

        describe("Brick tests") {

            it("should create a new brick target instance correctly") {
                // Given
                let brick = Brick(name: "title", targetClass: UILabel.self).width(40).height(60).style([.backgroundColor(UIColor.green)])

                // Then
                expect(brick.name) == "title"
                expect(brick.targetClass) === UILabel.self
                expect(brick.width) == 40
                expect(brick.height) == 60
                expect(brick.hashValue) == "title".hashValue
                if case let .backgroundColor(color) = brick.style!.first! {
                    expect(color) == UIColor.green
                }
            }

            it("should create a new brick with subbricks", closure: { () -> () in
                // Given
                let mockLayout = Layout()

                // When
                let brick = Brick(name: "header", targetClass: UIView.self).bricks(Brick(name: "title", targetClass: UILabel.self), layout: { (title) -> Layout in
                    expect(title) == "title"
                    return mockLayout
                })

                // Then
                expect(brick.bricks?.count) == 1
                expect(brick.bricks?.last?.name) == "title"
                expect(brick.layout) == mockLayout
            })

            it("should create a new brick with subbricks", closure: { () -> () in

                // Given
                let mockLayout = Layout()

                // When
                let brick = Brick(name: "header", targetClass: UIView.self).bricks(Brick(name: "title", targetClass: UILabel.self), Brick(name: "avatar", targetClass: UIImageView.self), layout: { (title, avatar) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    return mockLayout
                })

                // Then
                expect(brick.bricks?.count) == 2
                expect(brick.bricks?.last?.name) == "avatar"
                expect(brick.layout) == mockLayout
            })

            it("should create a new brick with subbricks", closure: { () -> () in
                // Given
                let mockLayout = Layout()

                // When
                let brick = Brick(name: "header", targetClass: UIView.self).bricks(TestData.title1, TestData.avatar1, TestData.view, layout: { (title, avatar, view) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    expect(view) == "view"
                    return mockLayout
                })

                // Then
                expect(brick.bricks?.count) == 3
                expect(brick.bricks?.last?.name) == "view"
                expect(brick.layout) == mockLayout
            })

            it("should create a new brick with subbricks", closure: { () -> () in

                // Given
                let mockLayout = Layout()

                // When
                let brick = Brick(name: "header", targetClass: UIView.self).bricks(TestData.title1, TestData.avatar1, TestData.view, TestData.title3, layout: { (title, avatar, view, title3) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    expect(view) == "view"
                    expect(title3) == "title3"
                    return mockLayout
                })

                // Then
                expect(brick.bricks?.count) == 4
                expect(brick.bricks?.last?.name) == "title3"
                expect(brick.layout) == mockLayout
            })

            it("should create a new brick with subbricks", closure: { () -> () in

                // Given
                let mockLayout = Layout()

                // When
                let brick = Brick(name: "header", targetClass: UIView.self).bricks(TestData.title1, TestData.avatar1, TestData.view, TestData.title3, TestData.header2, layout: { (title, avatar, view, title3, header2) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    expect(view) == "view"
                    expect(title3) == "title3"
                    expect(header2) == "header2"
                    return mockLayout
                })

                // Then
                expect(brick.bricks?.count) == 5
                expect(brick.bricks?.last?.name) == "header2"
                expect(brick.layout) == mockLayout
            })

            it("should create a new brick with subbricks", closure: { () -> () in
                // Given
                let mockLayout = Layout()

                // When
                let brick = Brick(name: "header", targetClass: UIView.self).bricks([TestData.title1, TestData.avatar1], layout: mockLayout)

                // Then
                expect(brick.bricks?.count) == 2
                expect(brick.bricks?.last?.name) == "avatar"
                expect(brick.layout) == mockLayout
            })

            it("should build brick target instance", closure: { () -> () in
                // Given
                let brick = BrickBuilder.header.build()

                // Then
                expect(brick.name) == "header"
                expect(brick.targetClass) === UIView.self
            })

            it("should build brick target instance from nib", closure: { () -> () in

                // Given
                let brick = BrickBuilder.title.buildFromNib(UILabel.self, nibName: "nibname")

                // Then
                expect(brick.name) == "title"
                expect(brick.targetClass) === UILabel.self
                expect(brick.nibName) == "nibname"
            })

            it("should build brick with cell height resolver", closure: { () -> () in

                // Given
                let brick = BrickBuilder.header.build().heightResolver { _, childrenHeights, _ in
                    return childrenHeights[0] + childrenHeights[1]
                }

                // Then
                expect(brick.name) == "header"
                expect(brick.targetClass) === UIView.self
                expect(brick.heightResolver!(fittingWidth:0, childrenHeights: [10, 20], metrics: LayoutMetrics())) == 30
            })

            it("builder & target should be equals") {
                XCTAssertTrue(BrickBuilder.header == Brick(name: "header"))
                XCTAssertTrue(Brick(name: "header") == BrickBuilder.header)
            }
        }
    }
}














