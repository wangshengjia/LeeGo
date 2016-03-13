//
//  DataForTests.swift
//  LeeGo
//
//  Created by Victor WANG on 25/02/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation
@testable import LeeGo

enum ComponentBuilder: ComponentBuilderType {

    case header, title, avatar

    static let types: [ComponentBuilder: AnyClass] = [title: UILabel.self]
}

struct TestData {
    static let title1 = ComponentBuilder.title.build().style([.font(UIFont(name: "Helvetica", size: 18)!), .defaultLabelText("Text")])
    static let title2 = ComponentBuilder.title.build().style([.font(UIFont(name: "Avenir", size: 12)!), .defaultLabelText("Text")])
    static let title3 = ComponentTarget(name: "title3", targetClass: UILabel.self).style([.font(UIFont(name: "Arial", size: 14)!)])

    static let avatar1 = ComponentBuilder.avatar.build(UIImageView).width(50).height(50).heightResolver {childrenHeights in 50}
    static let avatar2 = ComponentBuilder.avatar.build(UIImageView).style([.backgroundColor(UIColor.greenColor())]).width(60).height(80).heightResolver {childrenHeights in 80}

    static let view = ComponentTarget(name: "view").width(70).height(90)

    static let header1 = ComponentBuilder.header.build()
        .style([.backgroundColor(UIColor.redColor())])
        .components(
            title1, avatar1
            ) { title, avatar in
                Layout(components: [title, avatar], axis: .Vertical, align: .Left, distribution: .Fill, metrics: LayoutMetrics(20, 20, 20, 20, 10 ,10))
        }.heightResolver { (_, childrenHeights, _) in
            return childrenHeights[0] + childrenHeights[1]
    }

    static let header2 = ComponentTarget(name: "header2").components(
        title2, avatar2, view
        ) { title, avatar, view in
            Layout(components: [title, avatar, view], axis: .Horizontal, align: .Top, distribution: .Flow(3), metrics: LayoutMetrics(20, 20, 20, 20, 10 ,10))
    }

    static let header3 = ComponentTarget(name: "header3").components(
        title3, view
        ) { title, view in
            Layout(["H:|[\(title)]|", "V:|[\(view)]|"])
    }
}

