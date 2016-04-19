//
//  DataForTests.swift
//  LeeGo
//
//  Created by Victor WANG on 25/02/16.
//  Copyright © 2016 Victor Wang. All rights reserved.
//

import Foundation
@testable import LeeGo

struct TestData {
    static let title1 = BrickBuilder.title.build().style([.font(UIFont(name: "Helvetica", size: 18)!), .text("Text")])
    static let title2 = BrickBuilder.title.build().style([.font(UIFont(name: "Avenir", size: 12)!), .text("Text")])
    static let title3 = Brick(name: "title3", targetClass: UILabel.self).style([.font(UIFont(name: "Arial", size: 14)!)])

    static let avatar1 = BrickBuilder.avatar.build(UIImageView).width(50).height(50).heightResolver {childrenHeights in 50}
    static let avatar2 = BrickBuilder.avatar.build(UIImageView).style([.backgroundColor(UIColor.greenColor())]).width(60).height(80).heightResolver {childrenHeights in 80}

    static let view = Brick(name: "view").width(70).height(90)

    static let header1 = BrickBuilder.header.build()
        .style([.backgroundColor(UIColor.redColor())])
        .components(
            title1, avatar1
            ) { title, avatar in
                Layout(components: [title, avatar], axis: .Vertical, align: .Left, distribution: .Fill, metrics: LayoutMetrics(20, 20, 20, 20, 10 ,10))
        }.heightResolver { (_, childrenHeights, _) in
            return childrenHeights[0] + childrenHeights[1]
    }

    static let header2 = Brick(name: "header2").components(
        title2, avatar2, view
        ) { title, avatar, view in
            Layout(components: [title, avatar, view], axis: .Horizontal, align: .Top, distribution: .Flow(3), metrics: LayoutMetrics(20, 20, 20, 20, 10 ,10))
    }

    static let header3 = Brick(name: "header3").components(
        title3, view
        ) { title, view in
            Layout(["H:|[\(title)]|", "V:|[\(view)]|"])
    }
}

enum BrickBuilder: BrickBuilderType {
    // leaf components
    case title, subtitle, date, avatar
    case favoriteButton
    case adView

    // child components
    case header, footer

    // root components
    case zen, article, video, portfolio, alert, detailsView, featured
}

extension BrickBuilder {
    static let types: [BrickBuilder: AnyClass] = [
        title: UILabel.self,
        subtitle: UILabel.self,
        avatar: UIImageView.self,
        favoriteButton: UIButton.self,
        ]

    static let defaultMetrics = LayoutMetrics(20, 20, 20, 20, 10, 10)

}

extension BrickBuilder {
    func brick() -> Brick {
        switch self {
        case .article:
            return self.build().style([.backgroundColor(UIColor.whiteColor())])
                .components(
                    title.brick(),
                    subtitle.build().style(Style.H2.style()),
                    avatar.build().style(Style.I1.style()).width(68).heightResolver({ (fittingWidth, _, _) -> CGFloat in
                        return fittingWidth * 2 / 3
                    })) { title, subtitle, avatar in
                        Layout([
                            H(orderedViews: ["avatar", "title"]),
                            H(orderedViews: ["avatar", "subtitle"]),
                            V(orderedViews: ["title", "subtitle"], bottom: .bottom(.GreaterThanOrEqual)),
                            V(orderedViews: ["avatar"], bottom: .bottom(.GreaterThanOrEqual)),
                            ], metrics: BrickBuilder.defaultMetrics)
                }.heightResolver { (_, childrenHeights, metrics) -> CGFloat in
                    return childrenHeights[0] + childrenHeights[1] + metrics.top + metrics.bottom + metrics.spaceV
            }
        case .featured:
            return self.build()
                .components(
                    avatar.build().style(Style.I1.style()).heightResolver({ (fittingWidth, _, _) -> CGFloat in
                        return fittingWidth * 2 / 3
                    }),
                    title.build().style(Style.H3.style())
                ) { (avatar, title) -> Layout in
                    Layout(components: [avatar, title], axis: .Vertical, align: .Fill, distribution: .Fill)
                }.heightResolver { (_, childrenHeights, _) -> CGFloat in
                    return childrenHeights[0] + childrenHeights[1]
            }
        case .detailsView:
            return
                Brick.container("Container", within:
                    Brick.union(brickName, components: [
                        avatar.build().style([.backgroundColor(UIColor.redColor())]).width(50).height(100),
                        favoriteButton.brick().LGOutlet("favoriteButton"),
                        adView.build().width(150).height(80)
                        ],
                        axis: .Horizontal, align: .Top, distribution: .Flow(2), metrics: LayoutMetrics(120, 20, 20, 20, 10, 10)
                        ).style([.backgroundColor(UIColor.brownColor())])
            )

        case .header:
            return self.build()
                .style([.backgroundColor(UIColor.yellowColor()), .translatesAutoresizingMaskIntoConstraints(false)])
                .components(
                    avatar.build().style(Style.I1.style()),
                    title.build().style(Style.H3.style()),
                    favoriteButton.brick()
                ) { avatar, title, favoriteButton -> Layout in
                    Layout([
                        "H:|-left-[\(avatar)][title]-(>=spaceH)-[\(favoriteButton)]-right-|",
                        "V:|-top-[\(avatar)]-bottom-|",
                        "V:|-top-[\(title)]-bottom-|",
                        "V:|-top-[\(favoriteButton)]-bottom-|",
                        ],
                           metrics: BrickBuilder.defaultMetrics)
            }
        case .title:
            return self.build(UILabel).style(Style.H3.style())
        case .favoriteButton:
            return self.build().style(Style.BasicButton.style() + [.backgroundColor(UIColor.greenColor())])
        default:
            assertionFailure("Unknown component: \(self)")
            return self.build()
        }
    }
}

enum Style: String {
    // UILabel
    case H1, H2, H3

    // UIImageView
    case I1

    // UIButton
    case BasicButton, FavoriteButton

    func style() -> [Appearance] {
        switch self {
        case H1:
            return [.font(UIFont.systemFontOfSize(18)),
                    .textColor(UIColor.darkTextColor()),
                    .textAlignment(.Center),
                    .numberOfLines(0)]
        case H2:
            return [.font(UIFont.systemFontOfSize(12)),
                    .textColor(UIColor.lightGrayColor()),
                    .numberOfLines(0),
                    .text("Default text")]
        case H3:
            return [
                .attributedText([
                    [NSFontAttributeName: UIFont(name: "Helvetica", size: 16)!, NSForegroundColorAttributeName: UIColor.redColor()],
                    [kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor.darkTextColor()],
                    [NSFontAttributeName: UIFont(name: "Avenir", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                    ]),
                .numberOfLines(0),
                .translatesAutoresizingMaskIntoConstraints(false)]
        case I1:
            return [.backgroundColor(UIColor.greenColor()), .ratio(1.5)]
        case BasicButton:
            return [.buttonType(.Custom), .buttonTitle("OK", .Normal)]
        default:
            return []
        }
    }
}

