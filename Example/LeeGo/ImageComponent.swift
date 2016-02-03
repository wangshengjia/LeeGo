//
//  ImageComponent.swift
//  LeeGo
//
//  Created by Victor WANG on 22/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import LeeGo

class ImageComponent: UIImageView {

}

extension UIImageView {
    public override func handleCustomStyle(styles: [String: AnyObject]) {
        for (key, value) in styles {
            switch (key, value) {
            case (Styles.ratio3To2, let ratio as CGFloat):
                self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: ratio, constant: 0))
            default:
                break
            }
        }
    }
}