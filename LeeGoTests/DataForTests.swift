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
    static let title1 = ComponentBuilder.title.build().style([.font(UIFont(name: "Helvetica", size: 18)!)])
    static let title2 = ComponentBuilder.title.build().style([.font(UIFont(name: "Avenir", size: 12)!)])
    static let title3 = ComponentTarget(name: "title3", targetClass: UILabel.self).style([.font(UIFont(name: "Arial", size: 14)!)])

    static let avatar1 = ComponentBuilder.avatar.build(UIImageView)
    static let avatar2 = ComponentBuilder.avatar.build(UIImageView).style([.backgroundColor(UIColor.greenColor())])

    static let view = ComponentTarget(name: "view")

    static let header1 = ComponentBuilder.header.build()
        .style([.backgroundColor(UIColor.redColor())])
        .components(
            title1, avatar1
            ) { title, avatar in
                Layout(["H:|[\(title)][\(avatar)]|"])
    }

    static let header2 = ComponentTarget(name: "header2").components(
        title2, avatar2, view
        ) { title, avatar, view in
            Layout(["H:|[\(title)][\(avatar)]|", "V:|[\(view)]|"])
    }

    static let header3 = ComponentTarget(name: "header3").components(
        title3, view
        ) { title, view in
            Layout(["H:|[\(title)]|", "V:|[\(view)]|"])
    }
}

