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
    }
}

extension DetailsViewController {
    
    private func setup() {
        let title = "title".build(UILabel.self).style([.numberOfLines(0), .text("Lorem Ipsum is simply dummy text of the printing industry")])
        let description = "description".build(UILabel.self).style([.textColor(UIColor.lightGray), .numberOfLines(0), .font(UIFont.systemFont(ofSize: 14)), .text("Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")])
        let redBlock = "red".build().style(Style.redBlockStyle)
        let greenBlock = "green".build().style(Style.greenBlockStyle)
        let blueBlock = "blue".build(UIImageView.self).style(Style.blueBlockStyle + [.custom(["shadowColor": UIColor.brown, "shadowOpacity": 1.0])])

        let blocks = Brick.union("blocks", bricks: [
            redBlock.height(50),
            greenBlock.height(80),
            blueBlock.height(30)],
            axis: .horizontal, align: .top, distribution: .fillEqually, metrics: LayoutMetrics(10, 10, 10, 10, 10, 10)).style(Style.blocksStyle)

        let brick = "details".build().bricks(title, description, blocks) {
            title, description, blocks in
            Layout(bricks: [title, description, blocks], axis: .vertical, align: .fill, distribution: .flow(3), metrics: LayoutMetrics(84, 20, 20, 20, 10, 10))
        }

        self.view.lg_configureAs(brick, updatingStrategy: .always)
    }
}

extension UIView {
    public func lg_setupCustomStyle(style: [String: AnyObject]) {
        if let view = self as? UIImageView,
            let color = style["shadowColor"] as? UIColor,
            let opacity = style["shadowOpacity"] as? Float {
            view.layer.shadowColor = color.cgColor
            view.layer.shadowOpacity = opacity
        }
    }

    public func lg_removeCustomStyle(style: [String: AnyObject]) {
        if let view = self as? UIImageView,
            let _ = style["shadowColor"] as? UIColor,
            let _ = style["shadowOpacity"] as? Float {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.0
        }
    }
}

