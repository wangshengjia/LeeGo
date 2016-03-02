//
//  ComponentStore.swift
//  LeeGo
//
//  Created by Victor WANG on 29/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation

import LeeGo

enum Twitter: ComponentBuilderType {

    case name, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, retweetCount, likeButton, likeCount
    case retweetView, likeView
    case accountHeader, toolbarFooter, retweetHeader
    case tweet

    static let reuseIdentifiers = [name, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, retweetCount, likeButton, likeCount, retweetView, likeView, accountHeader, toolbarFooter, retweetHeader, tweet].map { (component) -> String in
        return String(component)
    }

    static let types: [Twitter: AnyClass] = [
        name: UILabel.self,
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

    func container() -> ComponentTarget {
        return ComponentTarget(name: String(self))
            .style([.backgroundColor(UIColor.whiteColor())])
            .components(configuration()) { (component) -> Layout in
                Layout(["H:|[\(component)]|", "V:|[\(component)]|"])
        }
    }

    func configuration() -> ComponentTarget {
        switch self {
        case .name:
            return build().style([.font(UIFont.boldSystemFontOfSize(16))])
        case .account:
            return build().style([.font(UIFont.systemFontOfSize(14))])
        case .avatar:
            return build().style([.ratio(1), .backgroundColor(UIColor.lightGrayColor())])
        case .tweetText:
            return build()
        case .tweetImage:
            return build().style([.ratio(0.5)])
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
                        "H:|[\(rtButton)]-interspaceH-[\(rtNumber)]|",
                        "V:|[\(rtButton)]|", "V:|[\(rtNumber)]|"
                        ])
            }
        case .likeView:
            return build().components(
                likeButton.configuration(),
                likeCount.configuration()
                ) { (likeButton, likeNumber) -> Layout in
                    Layout([
                        "H:|[\(likeButton)]-interspaceH-[\(likeNumber)]|",
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
        case .tweet:
            return build()
                .style([.backgroundColor(UIColor.whiteColor())])
                .components(
                    avatar.configuration(),
                    tweetText.configuration(),
                    toolbarFooter.configuration()) { (avatar, tweetText, toolbarFooter) in
                        Layout(["H:|-10-[\(avatar)(50)]-10-[\(tweetText)]-10-|",
                            "H:[\(avatar)]-10-[\(toolbarFooter)]-10-|",
                            "V:|-10-[\(avatar)]-(>=10)-|",
                            "V:|-10-[\(tweetText)]-10-[\(toolbarFooter)]-(>=10)-|"])
            }
        default:
            return build()
        }
    }
}



















