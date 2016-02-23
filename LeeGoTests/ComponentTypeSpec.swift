//
//  ComponentTypeSpecs.swift
//  LeeGo
//
//  Created by Victor WANG on 20/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//


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
                expect(view.backgroundColor) == UIColor.whiteColor()
            }
        }

        describe("Composable extension tests") {
            it("") {
                let view = UIView()
                view.configuration = ComponentTarget(name: "")
                // TODO: finish test
            }
        }

        describe("ComponentType") {
            it("apply diff") {
                let view = UIView()
                
                view.applyDiffTo(view, newConfiguration: ComponentTarget(name: "name"), dataSource: nil, updatingStrategy: .WhenComponentChanged)
            }
        }
    }
}


