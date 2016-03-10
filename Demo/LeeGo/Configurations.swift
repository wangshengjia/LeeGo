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

    static let defaultMetrics: MetricsValuesType = (20, 20, 20, 20, 10, 10)

    static let cellReuseIdentifiers = [zen, article, featured, video, portfolio, alert].map { (type) -> String in
        return String(type)
    }
}

extension ComponentBuilder {
    func componentTarget() -> ComponentTarget {
        switch self {
        case .article:
            return self.build().style([.backgroundColor(UIColor.whiteColor())])
                .components([
                    title.componentTarget(),
                    ComponentTarget(name: "subtitle", targetClass: UILabel.self).style(Style.H2.style()),
                    avatar.build(UIImageView).style(Style.I1.style()).cellHeightResolver({ (childrenHeights) -> CGFloat in
                        return 68 * 2 / 3
                    }),
                    ],
                    layout: Layout([
                        H(orderedViews: ["avatar", "title"]),
                        H("avatar", width: 68),
                        H(orderedViews: ["avatar", "subtitle"]),
                        V(orderedViews: ["title", "subtitle"], bottom: .bottom(.GreaterThanOrEqual)),
                        V(orderedViews: ["avatar"], bottom: .bottom(.GreaterThanOrEqual)),
                        ], ComponentBuilder.defaultMetrics)
                ).cellHeightResolver({ (childrenHeights) -> CGFloat in
                    return childrenHeights[0] + childrenHeights[1] + 20 + 20 + 10
                })
        case .featured:
            return self.build()
                .components(
                    avatar.build().style(Style.I1.style()).cellHeightResolver({ (childrenHeights) -> CGFloat in
                        return 375 * 2 / 3
                    }),
                    title.build().style(Style.H3.style())
                    ) { (avatar, title) -> Layout in
                        return Layout([
                            H(orderedViews: [title]),
                            H(orderedViews: [avatar]),
                            V(orderedViews: [title]),
                            V(orderedViews: [avatar]),
                            ])
                }
        case .detailsView:
            return
                self.build()
                    .style([.translatesAutoresizingMaskIntoConstraints(false)])
                    .components(
                        ComponentTarget(name: "content", targetClass: UIView.self)
                            .style([.backgroundColor(UIColor.brownColor()), .translatesAutoresizingMaskIntoConstraints(false)])
                            .components(
                                header.componentTarget(),
                                adView.buildFromNib(AdView.self, name: "AdView").style([.translatesAutoresizingMaskIntoConstraints(false)]),
                                layout: { (header, adView) -> Layout in
                                    return Layout([
                                        H(orderedViews: [header]),
                                        H(orderedViews: [adView]),
                                        V(adView, height: 80),
                                        "V:|[header]-80-[adView]-(>=bottom)-|"
                                        ])
                            }), layout: { content -> Layout in
                                Layout(["H:|[content]|", "V:|[content]|"])
                    })
            
        case .header:
            return self.build()
                .style([.backgroundColor(UIColor.yellowColor()), .translatesAutoresizingMaskIntoConstraints(false)])
                .components(
                    avatar.build(Icon).style(Style.I1.style()),
                    title.build().style(Style.H3.style()),
                    favoriteButton.componentTarget()
                    ) { avatar, title, favoriteButton -> Layout in
                        Layout([
                            H("|-left-[\(avatar)][title]-(>=interspaceH)-[\(favoriteButton)]-right-|"),
                            V("|-top-[\(avatar)]-bottom-|"),
                            V("|-top-[\(title)]-bottom-|"),
                            V("|-top-[\(favoriteButton)]-bottom-|"),
                            ],
                            ComponentBuilder.defaultMetrics)
            }
        case .title:
            return self.build(UILabel).style(Style.H3.style())
        case .favoriteButton:
            return self.build().style(Style.BasicButton.style())
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
                .numberOfLines(0),
                .translatesAutoresizingMaskIntoConstraints(false)]
        case H2:
            return [.font(UIFont.systemFontOfSize(12)),
                .textColor(UIColor.lightGrayColor()),
                .numberOfLines(0),
                .defaultLabelText("Default text"),
                .translatesAutoresizingMaskIntoConstraints(false)]
        case H3:
            return [
                .attributedText([
                    [kCustomAttributeKeyIdentifier: Style.marker, NSFontAttributeName: UIFont(name: "LmfrAppIcon", size: 16)!, NSForegroundColorAttributeName: UIColor.redColor()],
                    [kCustomAttributeKeyIdentifier: Style.customTitle, kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "TheAntiquaB-W7Bold", size: CGFloat(20.responsive([.S: 21, .L: 30])))!, NSForegroundColorAttributeName: UIColor.darkTextColor()],
                    [kCustomAttributeKeyIdentifier: Style.nature, NSFontAttributeName: UIFont(name: "FetteEngschrift", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                    ]),
                .numberOfLines(0),
                .translatesAutoresizingMaskIntoConstraints(false)]
        case I1:
            return [.backgroundColor(UIColor.greenColor()), .ratio(1.5), .translatesAutoresizingMaskIntoConstraints(false)]
        case BasicButton:
            return [.buttonType(.Custom), .buttonTitle("OK", .Normal), .translatesAutoresizingMaskIntoConstraints(false)]
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
//                        "H:|-left-[avatar(50)]-interspaceH-[\(title)]-(>=interspaceH)-[date]-right-|",
//                        "H:[avatar]-interspaceH-[subtitle]-right-|",
//                        "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
//                        "V:|-top-[avatar(50)]-(>=bottom)-|",
//                        "V:|-top-[date]-(>=bottom)-|"
//                        ], ConfigurationTarget.layoutMetrics)
//            }











