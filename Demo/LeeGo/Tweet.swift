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
    let hashTags: [[String: Any]]
    let text: String
    let retweetCount: Int
    let favouritesCount: Int
    let createdAt: NSDate
    let userName: String
    let screenName: String
    let avatarUrl: NSURL?

    init(json: [String: Any]) {
        id = json["id_str"] as? String ?? ""
        favorited = json["favorited"] as? Bool ?? false
        truncated = json["truncated"] as? Bool ?? false
        hashTags = json["hashtags"] as? [[String: Any]] ?? []
        text = json["text"] as? String ?? ""
        retweetCount = json["retweet_count"] as? Int ?? 0

        let user = json["user"] as? [String : Any]
        
        favouritesCount = user?["favourites_count"] as? Int ?? 0
        createdAt = NSDate()
        userName = user?["name"] as? String ?? ""
        screenName = user?["screen_name"] as? String ?? ""
        avatarUrl = NSURL(string: (json["profile_image_url_https"] as? String) ?? "")
    }
}

extension Tweet {
    static func tweets(jsonArray: [[String: Any]]) -> [Tweet] {
        return jsonArray.map({ (json) -> Tweet in
            return Tweet(json: json)
        })
    }
}

extension Tweet: BrickDataSource {

    func update(_ targetView: UIView, with brick: Brick) {
        switch targetView {
        case let textView as UITextView where brick == Twitter.tweetText:
            textView.text = text
        case let label as UILabel where brick == Twitter.username:
            label.text = userName
        case let label as UILabel where brick == Twitter.account:
            label.text = "@" + screenName
        case let label as UILabel where brick == Twitter.date:
            label.text = "2d" // just example
        case let button as UIButton where brick == Twitter.retweetButton:
            button.setTitle("\(retweetCount)", for: .normal)
        case let button as UIButton where brick == Twitter.likeButton:
            button.setTitle("\(favouritesCount)", for: .normal)
        default:
            break
        }
    }
}


extension UIButton {
    public override func lg_unapply(customStyle style: [String : Any]) {
        if let font = style["buttonTitleFont"] as? UIFont {
            self.titleLabel?.font = font
        }
    }

    public override func lg_apply(customStyle style: [String : Any]) {
        if let _ = style["buttonTitleFont"] as? UIFont {
            self.titleLabel?.font = nil
        }
    }
}

