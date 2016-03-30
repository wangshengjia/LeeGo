//
//  Test.swift
//  LeeGo
//
//  Created by Victor WANG on 24/02/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class AppearanceSpec: QuickSpec {
    override func spec() {
        describe("Appearance") {
            it("should return hashValue correctly.") {
                // Given
                let appearance = Appearance.backgroundColor(UIColor.redColor())

                // When
                let hashValue = appearance.hashValue

                // Then
                expect(hashValue) == "backgroundColor".hashValue
            }
        }
    }
}