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

    static let reuseIdentifiers = [name, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, retweetCount, likeButton, likeCount, retweetView, likeView, accountHeader, toolbarFooter, retweetHeader].map { (component) -> String in
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
    ]
}

extension Twitter {

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
            return build().style([.buttonImage(UIImage(named: "")!, .Normal)])
        case .retweetButton:
            return build().style([.buttonImage(UIImage(named: "")!, .Normal)])
        case .likeButton:
            return build().style([.buttonImage(UIImage(named: "")!, .Normal)])
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
                        "H:|[\(reply)]-interspaceH-[\(retweet)-interspaceH-[\(like)]|",
                        "V:|[\(reply)]|", "V:|[\(retweet)]|", "V:|[\(like)]|"
                        ])
            }
        default:
            return build()
        }
    }
}