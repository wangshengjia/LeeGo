//
//  Configurations.swift
//  LeeGo
//
//  Created by Victor WANG on 19/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import LeeGo

enum ComponentProvider: String, ComponentProviderType {
    case title, subtitle, date, avatar, header, footer, container

    static let types: [ComponentProvider: AnyClass] = [title: UILabel.self]
}

enum ConfigurationTarget: String {
    case Zen, Article, Featured, Video, Portfolio, Alert, Header, Footer

    static let allTypes = [Zen, Article, Featured, Video, Portfolio, Alert, Footer].map { (type) -> String in
        return type.rawValue
    }

    static let layoutMetrics = [
        "top":20,
        "bottom":20,
        "left":20,
        "right":20,
        "interspaceH":10,
        "interspaceV":10]

    struct Styles {
        static let None = StyleType()

        static let H1: StyleType = [.font: UIFont.systemFontOfSize(18), .textColor: UIColor.darkTextColor(), .textAlignment: NSNumber(integer:  NSTextAlignment.Center.rawValue), .numberOfLines: NSNumber(integer: 0), .translatesAutoresizingMaskIntoConstraints: NSNumber(bool: false)]
        static let H2: StyleType = [.font: UIFont.systemFontOfSize(12), .textColor: UIColor.lightGrayColor(), .numberOfLines: NSNumber(integer: 0), .translatesAutoresizingMaskIntoConstraints: NSNumber(bool: false)]
        static let H3: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.lightGrayColor(), .translatesAutoresizingMaskIntoConstraints: NSNumber(bool: false)]
        static let I1: StyleType = [.backgroundColor: UIColor.greenColor(), .Custom("3to2"): 1.5, .translatesAutoresizingMaskIntoConstraints: NSNumber(bool: false)]
    }

    func configuration() -> Configuration {
        switch self {
        case .Article:
            return Configuration(
                Styles.None,
                [
                    ComponentProvider.title.type(UILabel): Configuration(Styles.H1),
                    ComponentTarget(name: "subtitle", targetClass: UILabel.self): Configuration(Styles.H2),
                    ComponentProvider.avatar.type(ImageComponent): Configuration(Styles.I1)
                ],
                Layout([
                    "H:|-left-[avatar(50)]-interspaceH-[title]-right-|",
                    "H:[avatar]-interspaceH-[subtitle]-right-|",
                    "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
                    "V:|-top-[avatar]-(>=bottom)-|",
                    ], ConfigurationTarget.layoutMetrics)
            )
        case .Footer:
            return Configuration(
                Styles.None,
                [
                    ComponentProvider.title.type(): Configuration(Styles.H1),
                    ComponentProvider.subtitle.type(UILabel): Configuration(Styles.H2),
                ],
                Layout([
                    "H:|-left-[avatar(50)]-interspaceH-[title]-(>=interspaceH)-[date]-right-|",
                    "H:[avatar]-interspaceH-[subtitle]-right-|",
                    "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
                    "V:|-top-[avatar(50)]-(>=bottom)-|",
                    "V:|-top-[date]-(>=bottom)-|"
                    ], ConfigurationTarget.layoutMetrics)
            )
        default:
            assertionFailure("Configuration type not found")
            return Configuration()
        }
    }
    
}

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






































