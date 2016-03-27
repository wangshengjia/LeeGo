//
//  Conveniences.swift
//  Pods
//
//  Created by Victor WANG on 03/02/16.
//
//

import Foundation

public let kCustomAttributeKeyIdentifier = "kCustomAttributeKeyIdentifier"
public let kCustomAttributeDefaultText = "kCustomAttributeDefaultText"

func + <K,V>(left: [K: V], right: [K: V]) -> [K: V] {
    var result = [K: V]()
    for (k, v) in left {
        result[k] = v
    }
    for (k, v) in right {
        result[k] = v
    }
    return result
}

extension Dictionary {

    func filter(@noescape includeElement: (Key, Value) throws -> Bool) rethrows -> Dictionary {
        var result = self
        for (key, value) in result {
            if try !includeElement(key, value) {
                result.removeValueForKey(key)
            }
        }
        return result
    }
}

extension Dictionary {

    func parse<T>(key: JSONKeyType) throws -> T {
        return try parse(key.asString)
    }

    func parse<T>(key: String) throws -> T {
        if let value = self[key as! Key] {
            if let valueWithExpectedType = value as? T {
                return valueWithExpectedType
            } else {
                throw JSONParseError.MismatchedTypeError
            }
        } else {
            throw JSONParseError.UnexpectedKeyError
        }
    }

    func parse<T>(key: JSONKeyType, defaultValue: T) -> T {
        return parse(key.asString, defaultValue: defaultValue)
    }

    func parse<T>(key: String, defaultValue: T) -> T {
        if let value = self[key as! Key] as? T {
            return value
        }

        return defaultValue
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

