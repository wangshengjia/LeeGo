//
//  AutoLayoutSpec.swift
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

class AutoLayoutSpec: QuickSpec {
    override func spec() {
        it("Horizontal, Top, Fill") {
            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Top, distribution: .Fill, metrics: (20, 20 ,20, 20, 10 ,10))

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-interspaceH-[title]-interspaceH-[subtitle]-right-|",
                "V:|-top-[avatar]-(>=bottom)-|",
                "V:|-top-[title]-(>=bottom)-|",
                "V:|-top-[subtitle]-(>=bottom)-|"], (20, 20 ,20, 20, 10 ,10))
            
        }

        it("Horizontal, Bottom, Fill") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Bottom, distribution: .Fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-interspaceH-[title]-interspaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"], (0, 0 ,0, 0, 0 ,0))

        }

        it("Horizontal, Fill, Fill") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Fill, distribution: .Fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-interspaceH-[title]-interspaceH-[subtitle]-right-|",
                "V:|-top-[avatar]-bottom-|",
                "V:|-top-[title]-bottom-|",
                "V:|-top-[subtitle]-bottom-|"])
            
        }

        it("Horizontal, Center, Fill") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Center, distribution: .Fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-interspaceH-[title]-interspaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-(>=bottom)-|",
                "V:|-(>=top)-[title]-(>=bottom)-|",
                "V:|-(>=top)-[subtitle]-(>=bottom)-|"], options: [.AlignAllCenterY, .DirectionLeadingToTrailing])

        }

        it("Horizontal, Top, FillEqually") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Top, distribution: .FillEqually)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-interspaceH-[title]-interspaceH-[subtitle]-right-|",
                "H:[avatar(title)]",
                "H:[title(subtitle)]",
                "V:|-top-[avatar]-(>=bottom)-|",
                "V:|-top-[title]-(>=bottom)-|",
                "V:|-top-[subtitle]-(>=bottom)-|"], (0, 0 ,0, 0, 0 ,0))

        }

        it("Horizontal, Bottom, Flow(index)") {

            // Given
            let result1 = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Bottom, distribution: .Flow(-10))
            let result2 = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Bottom, distribution: .Flow(1))
            let result3 = layout(["avatar", "title", "subtitle"], axis: .Horizontal, align: .Bottom, distribution: .Flow(10))

            // Then
            expect(result1) == Layout([
                "H:|-(>=left)-[avatar]-interspaceH-[title]-interspaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"],
                (0, 0 ,0, 0, 0 ,0))

            expect(result2) == Layout([
                "H:|-left-[avatar]-(>=interspaceH)-[title]-interspaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"])

            expect(result3) == Layout([
                "H:|-left-[avatar]-interspaceH-[title]-interspaceH-[subtitle]-(>=right)-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"])
            
        }

        it("Vertical, Left, Fill") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Left, distribution: .Fill, metrics: (20, 20 ,20, 20, 10 ,10))

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-(>=right)-|",
                "H:|-left-[title]-(>=right)-|",
                "H:|-left-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-interspaceV-[title]-interspaceV-[subtitle]-bottom-|"],
                (20, 20 ,20, 20, 10 ,10))

        }

        it("Vertical, Right, Fill") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Right, distribution: .Fill)

            // Then
            expect(result) == Layout([
                "H:|-(>=left)-[avatar]-right-|",
                "H:|-(>=left)-[title]-right-|",
                "H:|-(>=left)-[subtitle]-right-|",
                "V:|-top-[avatar]-interspaceV-[title]-interspaceV-[subtitle]-bottom-|"],
                (0, 0 ,0, 0, 0 ,0))
            
        }

        it("Vertical, Fill, Fill") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Fill, distribution: .Fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-right-|",
                "H:|-left-[title]-right-|", "H:|-left-[subtitle]-right-|",
                "V:|-top-[avatar]-interspaceV-[title]-interspaceV-[subtitle]-bottom-|"],
                (0, 0 ,0, 0, 0 ,0))

        }

        it("Vertical, Center, Fill") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Center, distribution: .Fill)

            // Then
            expect(result) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|",
                "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-interspaceV-[title]-interspaceV-[subtitle]-bottom-|"],
                options: [.AlignAllCenterX, .DirectionLeadingToTrailing],
                (0, 0 ,0, 0, 0 ,0))

        }

        it("Vertical, Left, FillEqually") {

            // Given
            let result = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Left, distribution: .FillEqually, metrics: (20, 20 ,20, 20, 10 ,10))

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-(>=right)-|",
                "H:|-left-[title]-(>=right)-|",
                "H:|-left-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-interspaceV-[title]-interspaceV-[subtitle]-bottom-|",
                "V:[avatar(title)]",
                "V:[title(subtitle)]"],
                (20, 20 ,20, 20, 10 ,10))
            
        }

        it("Vertical, Center, Flow(index)") {

            // Given
            let result1 = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Center, distribution: .Flow(-10))
            let result2 = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Center, distribution: .Flow(2))
            let result3 = layout(["avatar", "title", "subtitle"], axis: .Vertical, align: .Center, distribution: .Flow(10))

            // Then
            expect(result1) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|",
                "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-(>=top)-[avatar]-interspaceV-[title]-interspaceV-[subtitle]-bottom-|"],
                options: [.AlignAllCenterX, .DirectionLeadingToTrailing])

            expect(result2) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|", "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-interspaceV-[title]-(>=interspaceV)-[subtitle]-bottom-|"],
                options: [.AlignAllCenterX, .DirectionLeadingToTrailing])

            expect(result3) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|",
                "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-interspaceV-[title]-interspaceV-[subtitle]-(>=bottom)-|"],
                options: [.AlignAllCenterX, .DirectionLeadingToTrailing])
            
        }

        it("H(customVFL: String) -> String") {

            // Given
            let format = H("[view(10.0)]")

            // Then
            expect(format) == "H:[view(10.0)]"
        }

        it("V(customVFL: String) -> String") {

            // Given
            let format = V("[view(10.0)]")

            // Then
            expect(format) == "V:[view(10.0)]"
        }
    }
}
