//
//  Configurations.swift
//  LeeGo
//
//  Created by Victor WANG on 19/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import LeeGo

enum ComponentProvider: ComponentProviderType {
    // leaf components
    case title, subtitle, date, avatar
    case favoriteButton
    case followButton, followTag

    // child components
    case header, footer, container
    case componentFromNib

    // root components
    case zen, article, video, portfolio, alert, detailsView, featured
}

extension ComponentProvider {
    static let types: [ComponentProvider: AnyClass] = [
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

extension ComponentProvider {
    func componentTarget() -> ComponentTarget? {
        switch self {
        case .article:
            return self.type()
                .components([
                    ComponentProvider.title.componentTarget()!,
                    ComponentTarget(name: "subtitle", targetClass: UILabel.self).style(Style.H2.style()),
                    ComponentProvider.avatar.type(UIImageView).style(Style.I1.style()),
                    ],
                    layout: Layout([
                        H(orderedViews: "avatar", "title"),
                        H("avatar", width: 68),
                        H(orderedViews: "avatar", "subtitle"),
                        V(orderedViews: ["title", "subtitle"], bottom: .bottom(.GreaterThanOrEqual)),
                        V(orderedViews: ["avatar"], bottom: .bottom(.GreaterThanOrEqual)),
                        ], ComponentProvider.defaultMetrics)
            )
        case .featured:
            return self.type()
                .components(
                    ComponentProvider.avatar.type().style(Style.I1.style()),
                    ComponentProvider.title.type().style(Style.H3.style())
                    ) { (avatar, title) -> Layout in
                        return Layout([
                            H(left:nil, orderedViews: title, right:nil),
                            H(left:nil, orderedViews: avatar, right:nil),
                            V(orderedViews: [title]),
                            V(top: nil, orderedViews: [avatar], bottom: nil),
                            ],
                            ComponentProvider.defaultMetrics)
            }
        case .detailsView:
            return self.type()
                .style([.backgroundColor(UIColor.brownColor())])
                .components(
                    ComponentProvider.header.componentTarget()!,
                    layout: { (header: String) -> Layout in
                        return Layout([
                            H(orderedViews: header),
                            V(orderedViews: [header], bottom: .bottom(.GreaterThanOrEqual))
                            ])
                })
        case .header:
            return self.type()
                .style([.translatesAutoresizingMaskIntoConstraints(false)])
                .components(
                    ComponentProvider.avatar.type().style(Style.I1.style()),
                    ComponentProvider.title.type().style(Style.H3.style()),
                    (ComponentProvider.favoriteButton.componentTarget())!
                    ) { (avatar, title, favoriteButton) -> Layout in
                        return Layout([
                            H(favoriteButton, width: 50),
                            V(favoriteButton, height: 50),
                            H(left:nil, orderedViews: title, right:nil),
                            H(left:nil, orderedViews: avatar, right:nil),
                            H(left: .left(.GreaterThanOrEqual), orderedViews: favoriteButton),
                            V(orderedViews: [title, favoriteButton]),
                            V(top: nil, orderedViews: [avatar], bottom: nil),
                            ],
                            ComponentProvider.defaultMetrics)
            }
        case .title:
            return self.type(UILabel).style(Style.H3.style())
        case .favoriteButton:
            return self.type().style(Style.BasicButton.style())
        default:
            return nil
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

    case None

    static let marker = "M"
    static let customTitle = "title"
    static let nature = "Nature"

    static let ratio3To2: String = "3to2"

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
                .translatesAutoresizingMaskIntoConstraints(false)]
        case H3:
            return [
                .attributedString([
                    [kCustomAttributeKeyIdentifier: Style.marker, NSFontAttributeName: UIFont(name: "LmfrAppIcon", size: 16)!, NSForegroundColorAttributeName: UIColor.redColor()],
                    [kCustomAttributeKeyIdentifier: Style.customTitle, kCustomAttributeDefaultText: "Test", NSFontAttributeName: UIFont(name: "TheAntiquaB-W7Bold", size: CGFloat(20.responsive([.S: 21, .L: 30])))!, NSForegroundColorAttributeName: UIColor.darkTextColor()],
                    [kCustomAttributeKeyIdentifier: Style.nature, NSFontAttributeName: UIFont(name: "FetteEngschrift", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                    ]),
                .numberOfLines(0),
                .translatesAutoresizingMaskIntoConstraints(false)]
        case I1:
            return [.backgroundColor(UIColor.greenColor()), .custom([Style.ratio3To2: 1.5]), .translatesAutoresizingMaskIntoConstraints(false)]
        case BasicButton:
            return [.buttonType(.Custom), .buttonTitle("OK", .Normal), .translatesAutoresizingMaskIntoConstraints(false)]
        default:
            return []
        }
    }
}


//enum ConfigurationTarget {
//    case Zen, Article, Featured, Video, Portfolio, Alert, Header, Footer, AnotherView
//
//    static let allTypes = [Zen, Article, Featured, Video, Portfolio, Alert, Footer].map { (type) -> String in
//        return String(type)
//    }
//
//    static let layoutMetrics = [
//        "top":20,
//        "bottom":20,
//        "left":20,
//        "right":20,
//        "interspaceH": 20.responsive([.S: 21, .L: 30]),
//        "interspaceV":10]
//
//    static let defaultMetrics: MetricsValuesType = (20, 20, 20, 20, 10, 10)
//
//    func configuration() -> Configuration {
//        // ComponentProvider.title.type()
//        // ComponentTarget(name: "subtitle", targetClass: UILabel.self).width(40.0).config(Zen.configuration())
//
//        switch self {
//        case .AnotherView:
//            return Configuration(
//                Style.None.style(),
//                [
//                    ComponentTarget(name: "view", targetClass: UILabel.self): Article.configuration(),
//                ],
//                Layout([
//                    "H:|-left-[view]-right-|",
//                    "V:|-top-[view]-bottom-|",
//                    ], ConfigurationTarget.layoutMetrics)
//            )
//        case .Article:
//            return Configuration(
//                Style.None.style(),
//                [
//                    ComponentProvider.title.type(UILabel): Configuration(Style.H3.style()),
//                    ComponentTarget(name: "subtitle", targetClass: UILabel.self): Configuration(Style.H2.style()),
//                    ComponentProvider.avatar.type(UIImageView): Configuration(Style.I1.style()),
//                ],
//                Layout([
//                    H(orderedViews: "avatar", "title"),
//                    H("avatar", width: 68),
//                    H(orderedViews: "avatar", "subtitle"),
//                    V(orderedViews: ["title", "subtitle"], bottom: .bottom(.GreaterThanOrEqual)),
//                    V(orderedViews: ["avatar"], bottom: .bottom(.GreaterThanOrEqual)),
//                    ], ConfigurationTarget.defaultMetrics)
//            )
//        case .Featured:
//            return Configuration(
//                Style.None.style(),
//                [
//                    ComponentProvider.avatar.type(ImageComponent): Configuration(Style.I1.style()),
//                    ComponentProvider.title.type(UILabel): Configuration(Styles.H3),
//                ],
//                Layout([
//                    H(left:nil, orderedViews:"title", right:nil),
//                    H(left:nil, orderedViews:"avatar", right:nil),
//                    H("avatar", width: 375),
//                    V(orderedViews: ["title"]),
//                    V(top: nil, orderedViews: ["avatar"], bottom: nil),
//                    ], ConfigurationTarget.defaultMetrics)
//            )
//        case .Footer:
//            return Configuration(
//                go: Style.None.style(),
//                [
//                    ComponentProvider.title.type(),
//                    ComponentProvider.subtitle.type()
//                ], { (components) -> (Layout?) in
//                    return Layout(
//                        layout1(components),
//                        ConfigurationTarget.layoutMetrics)
//            })
//        default:
//            assertionFailure("Configuration type not found")
//            return Configuration()
//        }
//    }
//    
//}
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






































