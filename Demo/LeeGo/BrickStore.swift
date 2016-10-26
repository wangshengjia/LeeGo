//
//  ComponentStore.swift
//  LeeGo
//
//  Created by Victor WANG on 29/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation

import LeeGo

protocol BrickConvertible {
    func brick() -> Brick
}

let defaultMetrics = LayoutMetrics(20, 20, 20, 20, 10, 10)

struct Style {
    static let titleBasicStyle: [Appearance] = [.text("Showcase"), .backgroundColor(UIColor(red: 0.921, green: 0.941, blue: 0.945, alpha: 1))]

    static let descriptionBasicStyle: [Appearance] = [.text("Showcase description"), .backgroundColor(UIColor(red: 0.921, green: 0.941, blue: 0.945, alpha: 1)), .textColor(UIColor.lightGray), .numberOfLines(0), .font(UIFont.systemFont(ofSize: 14))]

    static let blocksStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.945, green: 0.769, blue: 0.0588, alpha: 1)), .cornerRadius(3)]
    static let redBlockStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.906, green: 0.298, blue: 0.235, alpha: 1)), .cornerRadius(3)]
    static let greenBlockStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1)), .cornerRadius(3)]
    static let blueBlockStyle: [Appearance] = [.backgroundColor(UIColor(red: 0.204, green: 0.596, blue: 0.859, alpha: 1)), .cornerRadius(3)]

}

// MARK: Samples

enum SimpleShowcase: BrickBuilderType {
    case title, description
    case redBlock, greenBlock, blueBlock
    case showcase1, showcase2, showcase3, showcase4, showcase5, showcase6
    case showcase7, showcase8, showcase9, showcase10, showcase11, showcase12

    static let brickClass: [SimpleShowcase: AnyClass] = [
        title: UILabel.self,
        description: UILabel.self,
        ]
    
    static let reuseIdentifiers = [showcase1, showcase2, showcase3, showcase4, showcase5, showcase6, showcase7, showcase8, showcase9, showcase10, showcase11, showcase12].map { showcase -> String in
        return showcase.brickName
    };
}

extension SimpleShowcase: BrickConvertible {

    func brick() -> Brick {
        let blockMetrics = LayoutMetrics(10, 10, 10, 10, 10, 10)
        switch self {
        case .title:
            return build().style(Style.titleBasicStyle)
        case .description:
            return build().style(Style.descriptionBasicStyle)
        case .redBlock:
            return build().style(Style.redBlockStyle)
        case .greenBlock:
            return build().style(Style.greenBlockStyle)
        case .blueBlock:
            return build().style(Style.blueBlockStyle)

        // Horizontal cases
        case .showcase1:
            return Brick.union(brickName, bricks: [
                SimpleShowcase.title.brick(),
                SimpleShowcase.description.brick(),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().height(50),
                    SimpleShowcase.greenBlock.brick().height(80),
                    SimpleShowcase.blueBlock.brick().height(30)], axis: .horizontal, align: .top, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle)
                ], axis: .vertical, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase2:
            return Brick.union(brickName, bricks: [
                SimpleShowcase.title.brick(),
                SimpleShowcase.description.brick(),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().height(50),
                    SimpleShowcase.greenBlock.brick().height(80),
                    SimpleShowcase.blueBlock.brick().height(30)], axis: .horizontal, align: .center, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle)
                ], axis: .vertical, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase3:
            return Brick.union(brickName, bricks: [
                SimpleShowcase.title.brick(),
                SimpleShowcase.description.brick(),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().height(50),
                    SimpleShowcase.greenBlock.brick().height(80),
                    SimpleShowcase.blueBlock.brick().height(30)], axis: .horizontal, align: .bottom, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle)
                ], axis: .vertical, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase4:
            return build().bricks(
                SimpleShowcase.title.brick(),
                SimpleShowcase.description.brick(),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick(),
                    SimpleShowcase.greenBlock.brick(),
                    SimpleShowcase.blueBlock.brick()], axis: .horizontal, align: .fill, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle).height(100.0),
                layout: { (title, description, blocks) -> Layout in
                    Layout(bricks: [title, description, blocks], axis: .vertical, align: .fill, distribution: .fill, metrics: defaultMetrics)
            })
        case .showcase5:
            return Brick.union(brickName, bricks: [
                SimpleShowcase.title.brick(),
                SimpleShowcase.description.brick(),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().height(50).width(50),
                    SimpleShowcase.greenBlock.brick().height(80).width(100),
                    SimpleShowcase.blueBlock.brick().height(30)], axis: .horizontal, align: .bottom, distribution: .fill, metrics: blockMetrics).style(Style.blocksStyle)
                ], axis: .vertical, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase6:
            return Brick.union(brickName, bricks: [
                SimpleShowcase.title.brick(),
                SimpleShowcase.description.brick(),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().height(50).width(50),
                    SimpleShowcase.greenBlock.brick().height(80).width(100),
                    SimpleShowcase.blueBlock.brick().height(30).width(60)], axis: .horizontal, align: .bottom, distribution: .flow(1), metrics: blockMetrics).style(Style.blocksStyle)
                ], axis: .vertical, align: .fill, distribution: .fill, metrics: defaultMetrics)

        // Vertical cases
        case .showcase7:
            return Brick.union(brickName, bricks: [
                Brick.union("Comment", bricks: [
                    SimpleShowcase.title.brick(),
                    SimpleShowcase.description.brick()],
                    axis: .vertical, align: .left, distribution: .flow(2), metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().width(50),
                    SimpleShowcase.greenBlock.brick().width(80),
                    SimpleShowcase.blueBlock.brick().width(30)], axis: .vertical, align: .left, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle).height(300.0)
                ], axis: .horizontal, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase8:
            return Brick.union(brickName, bricks: [
                Brick.union("Comment", bricks: [
                    SimpleShowcase.title.brick(),
                    SimpleShowcase.description.brick()], axis: .vertical, align: .left, distribution: .flow(2), metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().width(50),
                    SimpleShowcase.greenBlock.brick().width(80),
                    SimpleShowcase.blueBlock.brick().width(30)], axis: .vertical, align: .center, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle).height(300.0)
                ], axis: .horizontal, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase9:
            return Brick.union(brickName, bricks: [
                Brick.union("Comment", bricks: [
                    SimpleShowcase.title.brick(),
                    SimpleShowcase.description.brick()], axis: .vertical, align: .left, distribution: .flow(2), metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().width(50),
                    SimpleShowcase.greenBlock.brick().width(80),
                    SimpleShowcase.blueBlock.brick().width(30)], axis: .vertical, align: .right, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle).height(300.0)
                ], axis: .horizontal, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase10:
            return build().bricks(
                Brick.union("Comment", bricks: [
                    SimpleShowcase.title.brick(),
                    SimpleShowcase.description.brick()], axis: .vertical, align: .left, distribution: .flow(2), metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick(),
                    SimpleShowcase.greenBlock.brick(),
                    SimpleShowcase.blueBlock.brick()], axis: .vertical, align: .fill, distribution: .fillEqually, metrics: blockMetrics).style(Style.blocksStyle).height(300.0).width(100.0),
                layout: { (comment, blocks) -> Layout in
                    Layout(bricks: [comment, blocks], axis: .horizontal, align: .fill, distribution: .fill, metrics: defaultMetrics)
            })
        case .showcase11:
            return Brick.union(brickName, bricks: [
                Brick.union("Comment", bricks: [
                    SimpleShowcase.title.brick(),
                    SimpleShowcase.description.brick()], axis: .vertical, align: .left, distribution: .flow(2), metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().height(50).width(50),
                    SimpleShowcase.greenBlock.brick().height(80).width(100),
                    SimpleShowcase.blueBlock.brick().width(30)], axis: .vertical, align: .left, distribution: .fill, metrics: blockMetrics).style(Style.blocksStyle).height(300.0)
                ], axis: .horizontal, align: .fill, distribution: .fill, metrics: defaultMetrics)
        case .showcase12:
            return Brick.union(brickName, bricks: [
                Brick.union("Comment", bricks: [
                    SimpleShowcase.title.brick(),
                    SimpleShowcase.description.brick()],
                    axis: .vertical, align: .left, distribution: .flow(2), metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)),
                Brick.union("blocks", bricks: [
                    SimpleShowcase.redBlock.brick().height(50).width(50),
                    SimpleShowcase.greenBlock.brick().height(80).width(100),
                    SimpleShowcase.blueBlock.brick().height(30).width(60)], axis: .vertical, align: .left, distribution: .flow(1), metrics: blockMetrics).style(Style.blocksStyle).height(300.0)
                ], axis: .horizontal, align: .fill, distribution: .fill, metrics: defaultMetrics)
        }
    }
}

// MARK: Le Monde

enum LeMonde: BrickBuilderType {
    case title, subtitle, illustration, icon
    case standard, featured, alert, live

    static let brickClass: [LeMonde: AnyClass] = [
        title: UILabel.self,
        subtitle: UILabel.self,
        illustration: UIImageView.self,
        icon: UIImageView.self,
        ]

    static let cellReuseIdentifiers = [standard, featured, alert, live].map { (type) -> String in
      return String(describing: type)
    }
}

extension LeMonde: BrickConvertible {
    func brick() -> Brick {
        switch self {
        case .title:
            return build().style([
                .attributedText([
                    [NSFontAttributeName: UIFont(name: "LmfrAppIcon", size: 16)!, NSForegroundColorAttributeName: UIColor.red],
                    [kCustomAttributeDefaultText: "Test" as AnyObject, NSFontAttributeName: UIFont(name: "TheAntiquaB-W7Bold", size: 20)!, NSForegroundColorAttributeName: UIColor.darkText],
                    [NSFontAttributeName: UIFont(name: "FetteEngschrift", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGray]
                    ]),
                .numberOfLines(0)
                ])
        case .subtitle:
            return build().style([
                .font(UIFont.systemFont(ofSize: 12)),
                .textColor(UIColor.lightGray),
                .numberOfLines(0),
                .text("Default text")])
        case .illustration:
            return build().style([.backgroundColor(UIColor.green), .ratio(1.5)]).heightResolver({ (fittingWidth, _, _) -> CGFloat in
                return fittingWidth * 2 / 3
            })
        case .icon:
            return build().style([.backgroundColor(UIColor.red)]).width(24).height(24)
        case .standard:
            return build().style([.backgroundColor(UIColor.white)])
                .bricks(
                    LeMonde.title.brick(),
                    LeMonde.subtitle.brick(),
                    LeMonde.illustration.brick().width(68)) { title, subtitle, illustration in
                        Layout([
                            H(orderedViews: [illustration, title]),
                            H(fromSuperview: false, orderedViews: [illustration, subtitle]),
                            V(orderedViews: [title, subtitle], bottom: .bottom(.greaterThanOrEqual)),
                            V(orderedViews: [illustration], bottom: .bottom(.greaterThanOrEqual)),
                            ], metrics: defaultMetrics)
                }.heightResolver { (_, childrenHeights, metrics) -> CGFloat in
                    // declare this variable to bypass a compiler warning
                    let children = childrenHeights[0] + childrenHeights[1]
                    return children + metrics.top + metrics.bottom + metrics.spaceV
            }
        case .featured:
            return build().bricks(
                LeMonde.illustration.brick(),
                LeMonde.title.brick()
            ) { (illustration, title) -> Layout in
                Layout(bricks: [illustration, title], axis: .vertical, align: .fill, distribution: .fill)
                }.heightResolver { (_, childrenHeights, _) -> CGFloat in
                    return childrenHeights[0] + childrenHeights[1]
            }
        case .alert:
            return build()
        case .live:
            return build().style([.backgroundColor(UIColor.white)])
                .bricks(
                    LeMonde.title.brick(),
                    LeMonde.subtitle.brick(),
                    LeMonde.illustration.brick().width(68).bricks(LeMonde.icon.brick(), layout: { (icon) -> Layout in
                        Layout(["H:|-8-[\(icon)]", "V:[\(icon)]-8-|"])
                    })
                ) { title, subtitle, illustration in
                    Layout([
                        H(orderedViews: [illustration, title]),
                        H(fromSuperview: false, orderedViews: [illustration, subtitle]),
                        V(orderedViews: [title, subtitle], bottom: .bottom(.greaterThanOrEqual)),
                        V(orderedViews: [illustration], bottom: .bottom(.greaterThanOrEqual)),
                        ], metrics: defaultMetrics)
                }.heightResolver { (_, childrenHeights, metrics) -> CGFloat in
                    // declare this variable to bypass a compiler warning
                    let children = childrenHeights[0] + childrenHeights[1]
                    return children + metrics.top + metrics.bottom + metrics.spaceV
            }
        }
    }
}

// MARK: Twitter

enum Twitter: BrickBuilderType {

    // leaf bricks
    case username, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, likeButton

    // complex bricks
    case accountHeader, toolbarFooter, retweetHeader

    // root bricks
    case tweet

    // reuseId of collection view
    static let reuseIdentifiers = [tweet].map { (component) -> String in
        return component.brickName
    }

    static let brickClass: [Twitter: AnyClass] = [
        username: UILabel.self,
        account: UILabel.self,
        avatar: UIImageView.self,
        tweetText: UITextView.self,
        tweetImage: UIImageView.self,
        date: UILabel.self,
        replyButton: UIButton.self,
        retweetButton: UIButton.self,
        likeButton: UIButton.self,
    ]
}

extension Twitter {

    func brick() -> Brick {
        switch self {
        case .username:
            return build().style([.font(UIFont.boldSystemFont(ofSize: 14))])
        case .account:
            return build().style([.font(UIFont.systemFont(ofSize: 14))])
        case .avatar:
            return build().style([.ratio(1), .backgroundColor(UIColor(red: 0.204, green: 0.596, blue: 0.859, alpha: 1)), .cornerRadius(3)]).width(50)
        case .tweetText:
            return build().style([.scrollEnabled(false), .lineFragmentPadding(0)])
        case .tweetImage:
            return build().style([.ratio(2), .backgroundColor(UIColor(red: 0.945, green: 0.769, blue: 0.0588, alpha: 1))])
        case .date:
            return build().style([.font(UIFont.systemFont(ofSize: 14))])
        case .replyButton:
            return build().style([.buttonImage(UIImage(named: "twitter_reply")!, .normal)])
        case .retweetButton:
            return build().style([.buttonImage(UIImage(named: "twitter_retweet")!, .normal), .buttonTitleColor(UIColor.black, .normal), .custom(["buttonTitleFont": UIFont.systemFont(ofSize: 14)])])
        case .likeButton:
            return build().style([.buttonImage(UIImage(named: "twitter_favorite")!, .normal), .buttonTitleColor(UIColor.black, .normal), .custom(["buttonTitleFont": UIFont.systemFont(ofSize: 14)])])
        case .toolbarFooter:
            return build().bricks(
                Twitter.replyButton.brick(),
                Twitter.retweetButton.brick(),
                Twitter.likeButton.brick()) { (reply, retweet, like) in
                    Layout([
                        "H:|[\(reply)]-50-[\(retweet)]-50-[\(like)]-(>=0)-|",
                        "V:|[\(reply)]|", "V:|[\(retweet)]|", "V:|[\(like)]|"
                        ])
            }
        case .accountHeader:
            return build().bricks(
                Twitter.username.brick(),
                Twitter.account.brick(),
                Twitter.date.brick()) { name, account, date in
                    Layout(["H:|[\(name)]-10-[\(account)]-(>=10)-[\(date)]|",
                        "V:|[\(name)]|", "V:|[\(account)]|", "V:|[\(date)]|"])
            }
        case .tweet:
            return build()
                .style([.backgroundColor(UIColor.white)])
                .bricks(
                    Twitter.avatar.brick(),
                    Twitter.accountHeader.brick(),
                    Twitter.tweetText.brick(),
                    Twitter.tweetImage.brick(),
                    Twitter.toolbarFooter.brick()
                ) { (avatar, accountHeader, tweetText, image, toolbarFooter) in
                    Layout(["H:|-10-[\(avatar)]-10-[\(tweetText)]-10-|",
                        "H:[\(avatar)]-10-[\(accountHeader)]-10-|",
                        "H:[\(avatar)]-10-[\(image)]-10-|",
                        "H:[\(avatar)]-10-[\(toolbarFooter)]-10-|",
                        "V:|-10-[\(avatar)]-(>=10)-|",
                        "V:|-10-[\(accountHeader)]-10-[\(tweetText)]-10-[\(image)]-10-[\(toolbarFooter)]-(>=10)-|"])
            }
        default:
            return build()
        }
    }
}














