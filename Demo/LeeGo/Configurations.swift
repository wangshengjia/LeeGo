//
//  Configurations.swift
//  LeeGo
//
//  Created by Victor WANG on 19/01/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import LeeGo


enum ComponentBuilder: ComponentBuilderType {
    // leaf components
    case title, subtitle, date, avatar
    case favoriteButton
    case adView

    // child components
    case header, footer

    // root components
    case zen, article, video, portfolio, alert, detailsView, featured
}

extension ComponentBuilder {
    static let types: [ComponentBuilder: AnyClass] = [
        title: UILabel.self,
        subtitle: UILabel.self,
        avatar: UIImageView.self,
        favoriteButton: UIButton.self,
    ]

    static let defaultMetrics = LayoutMetrics(20, 20, 20, 20, 10, 10)

    static let cellReuseIdentifiers = [zen, article, featured, video, portfolio, alert].map { (type) -> String in
        return String(type)
    }
}

extension ComponentBuilder {
    func componentTarget() -> ComponentTarget {
        switch self {
        case .article:
            return self.build().style([.backgroundColor(UIColor.whiteColor())])
                .components(
                    title.componentTarget(),
                    subtitle.build().style(Style.H2.style()),
                    avatar.build().style(Style.I1.style()).width(68).heightResolver({ (fittingWidth, _, _) -> CGFloat in
                        return fittingWidth * 2 / 3
                    })) { title, subtitle, avatar in
                        Layout([
                            H(orderedViews: ["avatar", "title"]),
                            H(orderedViews: ["avatar", "subtitle"]),
                            V(orderedViews: ["title", "subtitle"], bottom: .bottom(.GreaterThanOrEqual)),
                            V(orderedViews: ["avatar"], bottom: .bottom(.GreaterThanOrEqual)),
                            ], metrics: ComponentBuilder.defaultMetrics)
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
                ComponentTarget.container(self.name, within:
                    ComponentTarget.union(components: [
                        avatar.build(Icon).style([.backgroundColor(UIColor.redColor())]).width(50).height(100),
                        favoriteButton.componentTarget().LGOutlet("favoriteButton"),
                        adView.buildFromNib(AdView.self, nibName: "AdView").width(150).height(80)
                        ],
                        axis: .Horizontal, align: .Top, distribution: .Flow(2), metrics: LayoutMetrics(120, 20, 20, 20, 10, 10)
                    ).style([.backgroundColor(UIColor.brownColor())])
            )

        case .header:
            return self.build()
                .style([.backgroundColor(UIColor.yellowColor()), .translatesAutoresizingMaskIntoConstraints(false)])
                .components(
                    avatar.build(Icon).style(Style.I1.style()),
                    title.build().style(Style.H3.style()),
                    favoriteButton.componentTarget()
                    ) { avatar, title, favoriteButton -> Layout in
                        Layout([
                            H("|-left-[\(avatar)][title]-(>=spaceH)-[\(favoriteButton)]-right-|"),
                            V("|-top-[\(avatar)]-bottom-|"),
                            V("|-top-[\(title)]-bottom-|"),
                            V("|-top-[\(favoriteButton)]-bottom-|"),
                            ],
                            metrics: ComponentBuilder.defaultMetrics)
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

    // Ad View
    case AdView

    case None

    static let marker = "M"
    static let customTitle = "title"
    static let nature = "Nature"

    static let ratio: String = "ratio"

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
                    [NSFontAttributeName: UIFont(name: "LmfrAppIcon", size: 16)!, NSForegroundColorAttributeName: UIColor.redColor()],
                    [kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "TheAntiquaB-W7Bold", size: CGFloat(20.responsive([.S: 21, .L: 30])))!, NSForegroundColorAttributeName: UIColor.darkTextColor()],
                    [NSFontAttributeName: UIFont(name: "FetteEngschrift", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
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

//func someLayout() -> [String] {
//    return stackLayoutH(<#T##components: [String]##[String]#>)
//}

func stackLayoutH(components: [String]) -> [String] {
    return [H(orderedViews: components)]
}

func stackLayoutV(components: [String]) -> [String] {
    return [V(orderedViews: components, bottom: .bottom(.GreaterThanOrEqual))]
}

//
//func layout1(components: [String]) -> [String]{
//    return [
//        H(orderedViews: components[2], "title"),
//        H("avatar", width: 50),
//        H(fromSuperview: false, orderedViews: "avatar", "subtitle"),
//        V(orderedViews: ["title", "subtitle"], bottom: .bottom(.GreaterThanOrEqual)),
//        V(orderedViews: ["avatar"], bottom: .bottom(.GreaterThanOrEqual))
//    ]
//}

/** chain expression */
//            ComponentProvider.title
//                .type(ComponentTitle)
//                .width(40.0)
//                .config(Configuration(style: Styles.H1))

/** give exact components used with closure */
//            Configuration( Styles.None, [
//                ComponentProvider.title.type(ComponentTitle),
//                ComponentProvider.subtitle.type(ComponentTitle),
//                ]) { title, subtitle in return
//                    Layout([
//                        "H:|-left-[avatar(50)]-spaceH-[\(title)]-(>=spaceH)-[date]-right-|",
//                        "H:[avatar]-spaceH-[subtitle]-right-|",
//                        "V:|-top-[title]-spaceV-[subtitle]-(>=bottom)-|",
//                        "V:|-top-[avatar(50)]-(>=bottom)-|",
//                        "V:|-top-[date]-(>=bottom)-|"
//                        ], ConfigurationTarget.layoutMetrics)
//            }











