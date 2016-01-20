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
    case Zen, Article, Featured, Video, Portfolio, Alert, Footer

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

    func configuration() -> Configuration {
        switch self {
        case .Article:
            return Configuration(
                style: Styles.None,
                components: [
                    (ComponentTarget.title, Configuration(style: Styles.H1)),
                    (ComponentTarget.subtitle, Configuration(style: Styles.H2)),
                    // (.footer, Configurations.Footer.configuration())
                ],
                layout: Layout(
                    formats: [
                        "H:|-left-[\(ComponentTarget.title)]-right-|",
                        "H:|-left-[subtitle]-right-|",
                        "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
                    ],
                    metrics: ConfigurationTarget.layoutMetrics)
            )
        case .Footer:
            return Configuration(
                style: Styles.H1,
                components: [
                    (ComponentTarget.title, Configuration(style: Styles.H1)),
                    (ComponentTarget.subtitle, Configuration(style: Styles.H2)),
                ],
                layout: Layout(
                    formats: [
                        "H:|-left-[\(ComponentTarget.avatar)(50)]-interspaceH-[\(ComponentTarget.title)]-(>=interspaceH)-[\(ComponentTarget.date)]-right-|",
                        "H:[avatar]-interspaceH-[subtitle]-right-|",
                        "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
                        "V:|-top-[avatar(50)]-(>=bottom)-|",
                        "V:|-top-[date]-(>=bottom)-|"
                    ],
                    metrics: ConfigurationTarget.layoutMetrics)
            )
        default:
            assertionFailure("Configuration type not found")
            return Configuration()
        }
    }
    
}

enum ComponentTarget: String, ComponentTargetType {
    case title, subtitle, date, avatar, header, footer, container

    func availableComponentTypes() -> [String : AnyClass] {
        return [title: ComponentTitle.self,
            subtitle: ComponentSubtitle.self].rawStyle()
    }
}

struct Styles {
    static let None = StyleType()
    static let H1: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.grayColor(), .textAlignment: NSNumber(integer:  NSTextAlignment.Center.rawValue)]
    static let H2: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.redColor(), .numberOfLines: NSNumber(integer: 0)]
    static let H3: StyleType = [.font: UIFont.systemFontOfSize(15), .textColor: UIColor.lightGrayColor()]
    static let I1: StyleType = [.backgroundColor: UIColor.greenColor()]
}










































