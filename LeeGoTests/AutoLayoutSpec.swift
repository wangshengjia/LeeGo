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
        let metrics = LayoutMetrics(20, 20 ,20, 20, 10 ,10)

        it("Horizontal, Top, Fill") {
            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .top, distribution: .fill, metrics: metrics)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-spaceH-[title]-spaceH-[subtitle]-right-|",
                "V:|-top-[avatar]-(>=bottom)-|",
                "V:|-top-[title]-(>=bottom)-|",
                "V:|-top-[subtitle]-(>=bottom)-|"], metrics: metrics)
            
        }

        it("Horizontal, Bottom, Fill") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .bottom, distribution: .fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-spaceH-[title]-spaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"], metrics: LayoutMetrics())

        }

        it("Horizontal, Fill, Fill") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .fill, distribution: .fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-spaceH-[title]-spaceH-[subtitle]-right-|",
                "V:|-top-[avatar]-bottom-|",
                "V:|-top-[title]-bottom-|",
                "V:|-top-[subtitle]-bottom-|"])
            
        }

        it("Horizontal, Center, Fill") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .center, distribution: .fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-spaceH-[title]-spaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-(>=bottom)-|",
                "V:|-(>=top)-[title]-(>=bottom)-|",
                "V:|-(>=top)-[subtitle]-(>=bottom)-|"], options: [.alignAllCenterY, .directionLeadingToTrailing])

        }

        it("Horizontal, Top, FillEqually") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .top, distribution: .fillEqually)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-spaceH-[title]-spaceH-[subtitle]-right-|",
                "H:[avatar(title)]",
                "H:[title(subtitle)]",
                "V:|-top-[avatar]-(>=bottom)-|",
                "V:|-top-[title]-(>=bottom)-|",
                "V:|-top-[subtitle]-(>=bottom)-|"])

        }

        it("Horizontal, Bottom, Flow(index)") {

            // Given
            let result1 = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .bottom, distribution: .flow(-10))
            let result2 = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .bottom, distribution: .flow(1))
            let result3 = Layout(bricks: ["avatar", "title", "subtitle"], axis: .horizontal, align: .bottom, distribution: .flow(10))

            // Then
            expect(result1) == Layout([
                "H:|-(>=left)-[avatar]-spaceH-[title]-spaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"])

            expect(result2) == Layout([
                "H:|-left-[avatar]-(>=spaceH)-[title]-spaceH-[subtitle]-right-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"])

            expect(result3) == Layout([
                "H:|-left-[avatar]-spaceH-[title]-spaceH-[subtitle]-(>=right)-|",
                "V:|-(>=top)-[avatar]-bottom-|",
                "V:|-(>=top)-[title]-bottom-|",
                "V:|-(>=top)-[subtitle]-bottom-|"])
            
        }

        it("Vertical, Left, Fill") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .left, distribution: .fill, metrics: metrics)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-(>=right)-|",
                "H:|-left-[title]-(>=right)-|",
                "H:|-left-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-spaceV-[title]-spaceV-[subtitle]-bottom-|"],
                metrics: metrics)

        }

        it("Vertical, Right, Fill") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .right, distribution: .fill)

            // Then
            expect(result) == Layout([
                "H:|-(>=left)-[avatar]-right-|",
                "H:|-(>=left)-[title]-right-|",
                "H:|-(>=left)-[subtitle]-right-|",
                "V:|-top-[avatar]-spaceV-[title]-spaceV-[subtitle]-bottom-|"])
            
        }

        it("Vertical, Fill, Fill") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .fill, distribution: .fill)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-right-|",
                "H:|-left-[title]-right-|", "H:|-left-[subtitle]-right-|",
                "V:|-top-[avatar]-spaceV-[title]-spaceV-[subtitle]-bottom-|"])

        }

        it("Vertical, Center, Fill") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .center, distribution: .fill)

            // Then
            expect(result) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|",
                "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-spaceV-[title]-spaceV-[subtitle]-bottom-|"],
                options: [.alignAllCenterX, .directionLeadingToTrailing])

        }

        it("Vertical, Left, FillEqually") {

            // Given
            let result = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .left, distribution: .fillEqually, metrics: metrics)

            // Then
            expect(result) == Layout([
                "H:|-left-[avatar]-(>=right)-|",
                "H:|-left-[title]-(>=right)-|",
                "H:|-left-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-spaceV-[title]-spaceV-[subtitle]-bottom-|",
                "V:[avatar(title)]",
                "V:[title(subtitle)]"],
                metrics: metrics)
            
        }

        it("Vertical, Center, Flow(index)") {

            // Given
            let result1 = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .center, distribution: .flow(-10))
            let result2 = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .center, distribution: .flow(2))
            let result3 = Layout(bricks: ["avatar", "title", "subtitle"], axis: .vertical, align: .center, distribution: .flow(10))

            // Then
            expect(result1) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|",
                "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-(>=top)-[avatar]-spaceV-[title]-spaceV-[subtitle]-bottom-|"],
                options: [.alignAllCenterX, .directionLeadingToTrailing])

            expect(result2) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|", "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-spaceV-[title]-(>=spaceV)-[subtitle]-bottom-|"],
                options: [.alignAllCenterX, .directionLeadingToTrailing])

            expect(result3) == Layout([
                "H:|-(>=left)-[avatar]-(>=right)-|",
                "H:|-(>=left)-[title]-(>=right)-|",
                "H:|-(>=left)-[subtitle]-(>=right)-|",
                "V:|-top-[avatar]-spaceV-[title]-spaceV-[subtitle]-(>=bottom)-|"],
                options: [.alignAllCenterX, .directionLeadingToTrailing])
            
        }
    }
}
