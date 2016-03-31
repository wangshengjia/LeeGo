//
//  ConfigurationSpecs.swift
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

class LayoutSpec: QuickSpec {
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
    }
}
