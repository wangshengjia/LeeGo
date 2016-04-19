//
//  ComponentTypeSpecs.swift
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

class ComponentTypeSpec: QuickSpec {
    override func spec() {

        describe("Configurable extension tests") {
            it("should setup style correctly.") {
                let view = UIView()
                view.setup(view, newStyle: [.backgroundColor(UIColor.greenColor())])
                expect(view.backgroundColor) == UIColor.greenColor()
            }

            it("should remove style correctly.") {
                let view = UIView()
                view.setup(view, newStyle: [.backgroundColor(UIColor.greenColor())])
                expect(view.backgroundColor) == UIColor.greenColor()
                view.setup(view, currentStyle:[.backgroundColor(UIColor.greenColor())], newStyle: [])
                expect(view.backgroundColor).to(beNil())
            }
        }

        describe("ComponentType") {
            it("should apply diff to view correctly.") {
                // Given
                let superview = UIView()
                superview.translatesAutoresizingMaskIntoConstraints = false
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false

                // When
                view.apply(view, newConfiguration: Brick(name: "name").width(50).height(80), dataSource: nil, updatingStrategy: .WhenComponentChanged)

                superview.addSubview(view)
                view.setNeedsLayout()
                view.layoutIfNeeded()

                // Then
                expect(view.frame.width) == 50
                expect(view.frame.height) == 80
            }

            it("should apply diff to view correctly.") {
                // Given
                let superview = UIView()
                superview.translatesAutoresizingMaskIntoConstraints = false
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false

                // When
                view.apply(view, newConfiguration: Brick(name: "name").width(50).height(80), dataSource: nil, updatingStrategy: .WhenComponentChanged)

                view.apply(view, newConfiguration: Brick(name: "name").width(60).height(20), dataSource: nil, updatingStrategy: .Always)

                superview.addSubview(view)
                view.setNeedsLayout()
                view.layoutIfNeeded()

                // Then
                expect(view.frame.width) == 60
                expect(view.frame.height) == 20
                expect(view.constraints.count) == 2
            }

            it("should apply diff to view correctly.") {
                // Given
                let superview = UIView()
                superview.translatesAutoresizingMaskIntoConstraints = false
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false

                // When
                view.apply(view, newConfiguration: Brick(name: "name").width(50).height(80), dataSource: nil, updatingStrategy: .WhenComponentChanged)

                view.apply(view, newConfiguration: Brick(name: "name"), dataSource: nil, updatingStrategy: .WhenComponentChanged)

                superview.addSubview(view)
                view.setNeedsLayout()
                view.layoutIfNeeded()

                // Then
                expect(view.frame.width) == 0
                expect(view.frame.height) == 0
                expect(view.constraints) == []
            }
        }
    }
}


