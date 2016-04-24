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

        // This require XcodeInjection to work
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setup), name: "INJECTION_BUNDLE_NOTIFICATION", object: nil)
    }
}

extension DetailsViewController {
    
    func setup() {
        let title = "title".build().style([.text("Showcase 1")])
        let description = "description".build().style(SimpleShowcase.descriptionStyle + [.text("description")])
        let redBlock = "red".build().style([.backgroundColor(UIColor.redColor())])
        let greenBlock = "green".build().style([.backgroundColor(UIColor.greenColor())])
        let blueBlock = "blue".build().style([.backgroundColor(UIColor.blueColor())])

        let blocks = Brick.union("blocks", bricks: [
            redBlock.height(50),
            greenBlock.height(80),
            blueBlock.height(30)],
            axis: .Horizontal, align: .Top, distribution: .FillEqually, metrics: LayoutMetrics(10, 10, 10, 10, 10, 10)).style([.backgroundColor(UIColor.brownColor())])

        let brick = "details".build().bricks(title,description, blocks) {
            title, description, blocks in
            Layout(bricks: [title, description, blocks], axis: .Vertical, align: .Fill, distribution: .Flow(10), metrics: LayoutMetrics(84, 20, 20, 20, 10, 10))
        }
        
        self.view.configureAs(brick, updatingStrategy: .Always)
    }
}