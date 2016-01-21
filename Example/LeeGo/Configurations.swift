//
//  Configurations.swift
//  LeeGo
//
//  Created by Victor WANG on 19/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import LeeGo

enum ConfigurationTarget: String, ConfigurationTargetType {
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


    enum ComponentProvider: String, ComponentProviderType {
        case title, subtitle, date, avatar, header, footer, container
        
        static let types: [ComponentProvider: AnyClass] = [title: Label.self]
    }

    func configuration() -> Configuration {
        switch self {
        case .Article:
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
            return Configuration(
                Styles.None,
                [
                    ComponentProvider.title.type(ComponentTitle): Configuration(Styles.H1),
                    ComponentTarget(name: "subtitle", targetClass: ComponentTitle.self): Configuration(Styles.H2),
                    // (.footer, Configurations.Footer.configuration())
                ],
                Layout([
                    "H:|-left-[title]-right-|",
                    "H:|-left-[subtitle]-right-|",
                    "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
                    ], ConfigurationTarget.layoutMetrics)
            )
        case .Footer:
            return Configuration(
                Styles.None,
                [
                    ComponentProvider.title.type(): Configuration(Styles.H1),
                    ComponentProvider.subtitle.type(ComponentSubtitle): Configuration(Styles.H2),
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

struct Styles {
    static let None = StyleType()
    
    static let H1: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.grayColor(), .textAlignment: NSNumber(integer:  NSTextAlignment.Center.rawValue)]
    static let H2: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.redColor(), .numberOfLines: NSNumber(integer: 0)]
    static let H3: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.lightGrayColor()]
    static let I1: StyleType = [.backgroundColor: UIColor.greenColor()]
}










































