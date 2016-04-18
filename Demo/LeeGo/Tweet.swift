//
//  Tweet.swift
//  LeeGo
//
//  Created by Victor WANG on 29/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import LeeGo

struct Tweet {
    let id: String
    let favorited: Bool
    let truncated: Bool
    let hashTags: [[String: AnyObject]]
    let text: String
    let retweetCount: Int
    let favouritesCount: Int
    let createdAt: NSDate
    let userName: String
    let screenName: String
    let avatarUrl: NSURL?

    init(json: [String: AnyObject]) {
        id = json["id_str"] as? String ?? ""
        favorited = json["favorited"] as? Bool ?? false
        truncated = json["truncated"] as? Bool ?? false
        hashTags = json["hashtags"] as? [[String: AnyObject]] ?? []
        text = json["text"] as? String ?? ""
        retweetCount = json["retweet_count"] as? Int ?? 0
        favouritesCount = json["user"]!["favourites_count"] as? Int ?? 0
        createdAt = NSDate()
        userName = json["user"]!["name"] as? String ?? ""
        screenName = json["user"]!["screen_name"] as? String ?? ""
        avatarUrl = NSURL(string: (json["profile_image_url_https"] as? String) ?? "")
    }
}

extension Tweet {
    static func tweets(jsonArray: [[String: AnyObject]]) -> [Tweet] {
        return jsonArray.map({ (json) -> Tweet in
            return Tweet(json: json)
        })
    }
}

extension Tweet: ComponentDataSource {
    func updateComponent(componentView: UIView, with componentTarget: ComponentTarget) {
        switch componentView {
        case let textView as UITextView where componentTarget == Twitter.tweetText:
            textView.text = text
        case let label as UILabel where componentTarget == Twitter.username:
            label.text = userName
        case let label as UILabel where componentTarget == Twitter.account:
            label.text = "@" + screenName
        case let label as UILabel where componentTarget == Twitter.date:
            label.text = "2d"
        case let label as UILabel where componentTarget == Twitter.retweetCount:
            label.text = "\(retweetCount)"
        case let label as UILabel where componentTarget == Twitter.likeCount:
            label.text = "\(favouritesCount)"
        default:
            break
        }
    }
}