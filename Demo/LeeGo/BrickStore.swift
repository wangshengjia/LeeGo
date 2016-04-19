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

enum LeeGoShowcase: BrickBuilderType {
    case title, description
    case redBlock, greenBlock, blueBlock
    case showcase1, showcase2, showcase3, showcase4, showcase5, showcase6
//    case showcase1, showcase2, showcase3, showcase4, showcase5, showcase6

    static let types: [LeeGoShowcase: AnyClass] = [
        title: UILabel.self,
        description: UILabel.self,
        ]
    
    static let reuseIdentifiers = [showcase1, showcase2, showcase3, showcase4, showcase5, showcase6].map { brick -> String in
        return brick.name
    };
}

extension LeeGoShowcase: BrickConvertible {

    static let descriptionStyle: [Appearance] = [.textColor(UIColor.lightGrayColor()), .numberOfLines(0), .font(UIFont.systemFontOfSize(14))]

    func brick() -> Brick {
        switch self {
        case title:
            return build()
        case description:
            return build().style(LeeGoShowcase.descriptionStyle + [.text("description")])
        case .redBlock:
            return build().style([.backgroundColor(UIColor.redColor())])
        case .greenBlock:
            return build().style([.backgroundColor(UIColor.greenColor())])
        case .blueBlock:
            return build().style([.backgroundColor(UIColor.blueColor())])
        case showcase1:
            return Brick.union("showcase1", components: [
                title.brick().style([.text("Showcase 1")]),
                description.brick().style(LeeGoShowcase.descriptionStyle + [.text("Layout 3 blocks with `Top` alignment and `FillEqually` distribution")]),
                Brick.union("blocks", components: [
                    redBlock.brick().height(51),
                    greenBlock.brick().height(81),
                    blueBlock.brick().height(31)], axis: .Horizontal, align: .Top, distribution: .FillEqually, metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())])
                ], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
        case showcase2:
            return Brick.union("showcase2", components: [
                title.brick().style([.text("Showcase 2")]),
                description.brick().style(LeeGoShowcase.descriptionStyle + [.text("Layout 3 blocks with `Center` alignment and `FillEqually` distribution")]),
                Brick.union("blocks", components: [
                    redBlock.brick().height(50),
                    greenBlock.brick().height(80),
                    blueBlock.brick().height(30)], axis: .Horizontal, align: .Center, distribution: .FillEqually, metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())])
                ], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
        case showcase3:
            return Brick.union("showcase3", components: [
                title.brick().style([.text("Showcase 3")]),
                description.brick().style(LeeGoShowcase.descriptionStyle + [.text("Layout 3 blocks with `Bottom` alignment and `FillEqually` distribution")]),
                Brick.union("blocks", components: [
                    redBlock.brick().height(50),
                    greenBlock.brick().height(80),
                    blueBlock.brick().height(30)], axis: .Horizontal, align: .Bottom, distribution: .FillEqually, metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())])
                ], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
        case showcase4:
            return build().components(
                title.brick().style([.text("Showcase 4")]),
                description.brick().style(LeeGoShowcase.descriptionStyle + [.text("Layout 3 blocks with `Fill` alignment and `FillEqually` distribution")]),
                Brick.union("blocks", components: [
                    redBlock.brick(),
                    greenBlock.brick(),
                    blueBlock.brick()], axis: .Horizontal, align: .Fill, distribution: .FillEqually, metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())]).height(101.0),
                layout: { (title, description, blocks) -> Layout in
                    Layout(components: [title, description, blocks], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
            })
        case showcase5:
            return Brick.union(self.name, components: [
                title.brick().style([.text("Showcase 5")]),
                description.brick().style(LeeGoShowcase.descriptionStyle + [.text("Layout 3 blocks with `Bottom` alignment and `Fill` distribution. Red block and green block have fixed width")]),
                Brick.union("blocks", components: [
                    redBlock.brick().height(50).width(50),
                    greenBlock.brick().height(80).width(100),
                    blueBlock.brick().height(30)], axis: .Horizontal, align: .Bottom, distribution: .Fill, metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())])
                ], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
        case showcase6:
            return Brick.union(self.name, components: [
                title.brick().style([.text("Showcase 6")]),
                description.brick().style(LeeGoShowcase.descriptionStyle + [.text("Layout 3 blocks with `Top` alignment and `Flow(1)` distribution. All three blocks have fixed width")]),
                Brick.union("blocks", components: [
                    redBlock.brick().height(50).width(50),
                    greenBlock.brick().height(80).width(100),
                    blueBlock.brick().height(30).width(60)], axis: .Horizontal, align: .Bottom, distribution: .Flow(1), metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())])
                ], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
        }
    }
}

enum LeMonde: BrickBuilderType {
    case title, subtitle

    static let types: [LeMonde: AnyClass] = [
        title: UILabel.self,
        subtitle: UILabel.self,
        ]
}

enum Twitter: BrickBuilderType {

    case username, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, retweetCount, likeButton, likeCount
    case retweetView, likeView
    case accountHeader, toolbarFooter, retweetHeader
    case tweet

    static let reuseIdentifiers = [username, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, retweetCount, likeButton, likeCount, retweetView, likeView, accountHeader, toolbarFooter, retweetHeader, tweet].map { (component) -> String in
        return component.name
    }

    static let types: [Twitter: AnyClass] = [
        username: UILabel.self,
        account: UILabel.self,
        avatar: UIImageView.self,
        tweetText: UITextView.self,
        tweetImage: UIImageView.self,
        date: UILabel.self,
        replyButton: UIButton.self,
        retweetButton: UIButton.self,
        likeButton: UIButton.self,
        retweetCount: UILabel.self,
        likeCount: UILabel.self,
    ]
}

extension Twitter {

    func configuration() -> Brick {
        switch self {
        case .username:
            return build().style([.font(UIFont.boldSystemFontOfSize(14))])
        case .account:
            return build().style([.font(UIFont.systemFontOfSize(14))])
        case .avatar:
            return build().style([.ratio(1), .backgroundColor(UIColor.lightGrayColor()), .cornerRadius(3)]).width(50)
        case .tweetText:
            return build().style([.scrollEnabled(false)])
        case .tweetImage:
            return build().style([.ratio(2), .backgroundColor(UIColor.blueColor())])
        case .date:
            return build().style([.font(UIFont.systemFontOfSize(14))])
        case .replyButton:
            return build().style([.buttonImage(UIImage(named: "twitter_reply")!, .Normal)])
        case .retweetButton:
            return build().style([.buttonImage(UIImage(named: "twitter_retweet")!, .Normal)])
        case .likeButton:
            return build().style([.buttonImage(UIImage(named: "twitter_favorite")!, .Normal)])
        case .retweetCount:
            return build().style([.font(UIFont.systemFontOfSize(14))])
        case .likeCount:
            return build().style([.font(UIFont.systemFontOfSize(14))])
        case .retweetView:
            return build().components(
                retweetButton.configuration(),
                retweetCount.configuration()
                ) { (rtButton, rtNumber) -> Layout in
                    Layout([
                        "H:|[\(rtButton)]-spaceH-[\(rtNumber)]|",
                        "V:|[\(rtButton)]|", "V:|[\(rtNumber)]|"
                        ])
            }
        case .likeView:
            return build().components(
                likeButton.configuration(),
                likeCount.configuration()
                ) { (likeButton, likeNumber) -> Layout in
                    Layout([
                        "H:|[\(likeButton)]-spaceH-[\(likeNumber)]|",
                        "V:|[\(likeButton)]|", "V:|[\(likeNumber)]|"
                        ])
            }
        case .toolbarFooter:
            return build().components(
                replyButton.configuration(),
                retweetView.configuration(),
                likeView.configuration()) { (reply, retweet, like) in
                    Layout([
                        "H:|[\(reply)]-50-[\(retweet)]-50-[\(like)]-(>=0)-|",
                        "V:|[\(reply)]|", "V:|[\(retweet)]|", "V:|[\(like)]|"
                        ])
            }
        case .accountHeader:
            return build().components(
                username.configuration(),
                account.configuration(),
                date.configuration()) { name, account, date in
                    Layout(["H:|[\(name)]-10-[\(account)]-(>=10)-[\(date)]|",
                        "V:|[\(name)]|", "V:|[\(account)]|", "V:|[\(date)]|"])
            }
        case .tweet:
            return build()
                .style([.backgroundColor(UIColor.whiteColor())])
                .components(
                    avatar.configuration(),
                    accountHeader.configuration(),
                    tweetText.configuration(),
                    tweetImage.configuration(),
                    toolbarFooter.configuration()) { (avatar, accountHeader, tweetText, image, toolbarFooter) in
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














