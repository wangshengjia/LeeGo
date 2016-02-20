//
//  ConfigurationSpecs.swift
//  LeeGo
//
//  Created by Victor WANG on 20/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import LeeGo

class ConfigurationSpec: QuickSpec {
    override func spec() {

        describe("Configuration tests") {
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
    }
}
