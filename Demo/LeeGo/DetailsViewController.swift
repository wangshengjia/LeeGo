//
//  DetailsViewController.swift
//  LeeGo
//
//  Created by Victor WANG on 24/04/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import UIKit

import LeeGo

class DetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        // This requires XcodeInjection to work
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setup), name: "INJECTION_BUNDLE_NOTIFICATION", object: nil)
    }
}

extension DetailsViewController {
    
    func setup() {
        let title = "title".build(UILabel).style([.numberOfLines(0), .text("Lorem Ipsum is simply dummy text of the printing industry")])
        let description = "description".build(UILabel).style([.textColor(UIColor.lightGrayColor()), .numberOfLines(0), .font(UIFont.systemFontOfSize(14)), .text("Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")])
        let redBlock = "red".build().style(Style.redBlockStyle)
        let greenBlock = "green".build().style(Style.greenBlockStyle)
        let blueBlock = "blue".build().style(Style.blueBlockStyle)

        let blocks = Brick.union("blocks", bricks: [
            redBlock.height(50),
            greenBlock.height(80),
            blueBlock.height(30)],
            axis: .Horizontal, align: .Top, distribution: .FillEqually, metrics: LayoutMetrics(10, 10, 10, 10, 10, 10)).style(Style.blocksStyle)

        let brick = "details".build().bricks(title, description, blocks) {
            title, description, blocks in
            Layout(bricks: [title, description, blocks], axis: .Vertical, align: .Fill, distribution: .Flow(3), metrics: LayoutMetrics(84, 20, 20, 20, 10, 10))
        }

        self.view.configureAs(brick, updatingStrategy: .Always)
    }
}