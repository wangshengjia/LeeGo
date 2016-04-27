//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import LeeGo

/// Create the bricks inside cell brick
///
/// ![img title](https://raw.githubusercontent.com/wangshengjia/LeeGo/more-docs/Medias/title_sample.png)
let titleBrick = "title".build(UILabel).style([.text("default title"), .numberOfLines(0)])
let subtitleBrick = "subtitle".build(UILabel)
let imageBrick = "image".build(UIImageView).style([.ratio(1.5)]).width(68)
//
///// Create a brick stand for `UIView` which contains a `title`,
///// a `subtitle` and an `image` inside, layout them with
///// standard auto layout VFL.
//let cellBrick = "cell".build().style([.backgroundColor(UIColor.whiteColor())])
//    .bricks(titleBrick, subtitleBrick, imageBrick) { title, subtitle, image in
//        Layout(["H:|-left-[\(title)]-spaceH-[\(image)]-right-|",
//            "H:|-left-[\(subtitle)]-spaceH-[\(image)]",
//            "V:|-top-[\(title)]-spaceV-[\(subtitle)]-(>=bottom)-|",
//            "V:|-top-[\(image)]-(>=bottom)-|"],options:nil, LayoutMetrics(20, 20, 20, 20, 10, 10))
//}
//
//
//
//let cell = UICollectionViewCell()
//cell.configureAs(cellBrick)
//
//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//XCPlaygroundPage.currentPage.liveView = cell

