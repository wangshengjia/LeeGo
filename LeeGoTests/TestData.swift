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

    static let avatar1 = BrickBuilder.avatar.build(UIImageView.self).width(50).height(50).heightResolver {childrenHeights in 50}
    static let avatar2 = BrickBuilder.avatar.build(UIImageView.self).style([.backgroundColor(UIColor.green)]).width(60).height(80).heightResolver {childrenHeights in 80}

    static let view = Brick(name: "view").width(70).height(90)

    static let header1 = BrickBuilder.header.build()
        .style([.backgroundColor(UIColor.red)])
        .bricks(
            title1, avatar1
            ) { title, avatar in
                Layout(bricks: [title, avatar], axis: .vertical, align: .left, distribution: .fill, metrics: LayoutMetrics(20, 20, 20, 20, 10 ,10))
        }.heightResolver { (_, childrenHeights, _) in
            return childrenHeights[0] + childrenHeights[1]
    }

    static let header2 = Brick(name: "header2").bricks(
        title2, avatar2, view
        ) { title, avatar, view in
            Layout(bricks: [title, avatar, view], axis: .horizontal, align: .top, distribution: .flow(3), metrics: LayoutMetrics(20, 20, 20, 20, 10 ,10))
    }

    static let header3 = Brick(name: "header3").bricks(
        title3, view
        ) { title, view in
            Layout(["H:|[\(title)]|", "V:|[\(view)]|"])
    }
}

enum BrickBuilder: BrickBuilderType {
    // leaf bricks
    case title, subtitle, date, avatar
    case favoriteButton
    case adView

    // child bricks
    case header, footer

    // root bricks
    case zen, article, video, portfolio, alert, detailsView, featured
}

extension BrickBuilder {
    static let brickClass: [BrickBuilder: AnyClass] = [
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
            return self.build().style([.backgroundColor(UIColor.white)])
                .bricks(
                    BrickBuilder.title.brick(),
                    BrickBuilder.subtitle.build().style(Style.H2.style()),
                    BrickBuilder.avatar.build().style(Style.I1.style()).width(68).heightResolver({ (fittingWidth, _, _) -> CGFloat in
                        return fittingWidth * 2 / 3
                    })) { title, subtitle, avatar in
                        Layout([
                            H(orderedViews: ["avatar", "title"]),
                            H(orderedViews: ["avatar", "subtitle"]),
                            V(orderedViews: ["title", "subtitle"], bottom: .bottom(.greaterThanOrEqual)),
                            V(orderedViews: ["avatar"], bottom: .bottom(.greaterThanOrEqual)),
                            ], metrics: BrickBuilder.defaultMetrics)
                }.heightResolver { (_, childrenHeights, metrics) -> CGFloat in
                    let children = childrenHeights[0] + childrenHeights[1]
                    return children + metrics.top + metrics.bottom + metrics.spaceV
            }
        case .featured:
            return self.build()
                .bricks(
                    BrickBuilder.avatar.build().style(Style.I1.style()).heightResolver({ (fittingWidth, _, _) -> CGFloat in
                        return fittingWidth * 2 / 3
                    }),
                    BrickBuilder.title.build().style(Style.H3.style())
                ) { (avatar, title) -> Layout in
                    Layout(bricks: [avatar, title], axis: .vertical, align: .fill, distribution: .fill)
                }.heightResolver { (_, childrenHeights, _) -> CGFloat in
                    return childrenHeights[0] + childrenHeights[1]
            }
        case .detailsView:
            return
                Brick.container("Container", within:
                    Brick.union(brickName, bricks: [
                        BrickBuilder.avatar.build().style([.backgroundColor(UIColor.red)]).width(50).height(100),
                        BrickBuilder.favoriteButton.brick().LGOutlet("favoriteButton"),
                        BrickBuilder.adView.build().width(150).height(80)
                        ],
                        axis: .horizontal, align: .top, distribution: .flow(2), metrics: LayoutMetrics(120, 20, 20, 20, 10, 10)
                        ).style([.backgroundColor(UIColor.brown)])
            )

        case .header:
            return self.build()
                .style([.backgroundColor(UIColor.yellow), .translatesAutoresizingMaskIntoConstraints(false)])
                .bricks(
                    BrickBuilder.avatar.build().style(Style.I1.style()),
                    BrickBuilder.title.build().style(Style.H3.style()),
                    BrickBuilder.favoriteButton.brick()
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
            return self.build(UILabel.self).style(Style.H3.style())
        case .favoriteButton:
            return self.build().style(Style.BasicButton.style() + [.backgroundColor(UIColor.green)])
        default:
            assertionFailure("Unknown brick: \(self)")
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
        case .H1:
            return [.font(UIFont.systemFont(ofSize: 18)),
                    .textColor(UIColor.darkText),
                    .textAlignment(.center),
                    .numberOfLines(0)]
        case .H2:
            return [.font(UIFont.systemFont(ofSize: 12)),
                    .textColor(UIColor.lightGray),
                    .numberOfLines(0),
                    .text("Default text")]
        case .H3:
            return [
                .attributedText([
                    [NSFontAttributeName: UIFont(name: "Helvetica", size: 16)!, NSForegroundColorAttributeName: UIColor.red],
                    [kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor.darkText],
                    [NSFontAttributeName: UIFont(name: "Avenir", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGray]
                    ]),
                .numberOfLines(0),
                .translatesAutoresizingMaskIntoConstraints(false)]
        case .I1:
            return [.backgroundColor(UIColor.green), .ratio(1.5)]
        case .BasicButton:
            return [.buttonType(.custom), .buttonTitle("OK", .normal)]
        default:
            return []
        }
    }
}

