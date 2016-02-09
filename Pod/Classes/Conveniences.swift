//
//  Conveniences.swift
//  Pods
//
//  Created by Victor WANG on 03/02/16.
//
//

import Foundation

public let kCustomAttributeKeyIdentifier = "kCustomAttributeKeyIdentifier"

public extension Dictionary {
    func merge(dictionary: Dictionary<Key, Value>) {
        
    }
}

public extension UILabel {
    func setAttributeString(with texts: [String: String]) {
        if let attributeString = self.attributedText where attributeString.length > 0 {
            let range = NSRange(location: 0, length: attributeString.length)
            var attributes = [[String: AnyObject]]()
            attributeString.enumerateAttributesInRange(range, options: .LongestEffectiveRangeNotRequired, usingBlock: { (attribute, range, stop) -> Void in
                attributes.append(attribute)
            })
            let attributedStrings = attributes.flatMap({ (attribute) -> NSAttributedString? in
                if let customId = attribute[kCustomAttributeKeyIdentifier] as? String, let text = texts[customId] where !text.isEmpty {
                    return NSAttributedString(string: text, attributes: attribute)
                }
                return nil
            })

            self.attributedText = attributedStrings.combineToAttributedString()
        }
    }
}

public extension Array where Element: NSAttributedString {
    func combineToAttributedString() -> NSAttributedString? {
        guard let first = self.first else {
            return nil
        }

        guard self.count > 1 else {
            return first
        }

        return self.reduce(first, combine: { (acc, cur) -> NSAttributedString in
            if acc == cur {
                return acc
            }
            
            let str1 = acc.mutableCopy()
            str1.appendAttributedString(cur)
            return str1.copy() as! NSAttributedString
        })
    }
}

