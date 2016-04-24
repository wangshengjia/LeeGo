//
//  Conveniences.swift
//  LeeGo
//
//  Created by Victor WANG on 03/02/16.
//
//

import Foundation

// MARK: Dictionary

internal func + <K,V>(left: [K: V], right: [K: V]) -> [K: V] {
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

    internal func filter(@noescape includeElement: (Key, Value) throws -> Bool) rethrows -> Dictionary {
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

    internal func parse<T>(key: JSONKeyType) throws -> T {
        return try parse(key.asString)
    }

    internal func parse<T>(key: String) throws -> T {
        if let value = self[key as! Key] {
            if let valueWithExpectedType = value as? T {
                return valueWithExpectedType
            } else {
                throw JSONParseError.MismatchedTypeError(type: value.dynamicType, expectedType: T.self)
            }
        } else {
            throw JSONParseError.UnexpectedKeyError(key: key)
        }
    }

    internal func parse<T>(key: JSONKeyType, _ defaultValue: T) -> T {
        return parse(key.asString, defaultValue)
    }

    internal func parse<T>(key: String, _ defaultValue: T) -> T {
        if let value = self[key as! Key] as? T {
            return value
        }

        return defaultValue
    }
}

// MARK: NSAttributedString

public let kCustomAttributeDefaultText = "kCustomAttributeDefaultText"

extension UILabel {
    public func updatedAttributedString(with texts: [String?]) -> NSAttributedString? {
        return UIView.updatedAttributedString(with: texts, attributesArray: attributesArray)
    }
}

extension UITextField {
    public func updatedAttributedString(with texts: [String?]) -> NSAttributedString? {
        return UIView.updatedAttributedString(with: texts, attributesArray: attributesArray)
    }
}

extension UITextView {
    public func updatedAttributedString(with texts: [String?]) -> NSAttributedString? {
        return UIView.updatedAttributedString(with: texts, attributesArray: attributesArray)
    }
}

extension UIView {

    internal func setAttributedString(with attributesArray: [Attributes]) {
        let attributedString = UIView.attributedString(with: attributesArray)

        if let label = self as? UILabel {
            label.attributedText = attributedString
        } else if let textField = self as? UITextField {
            textField.attributedText = attributedString
        } else if let textView = self as? UITextView {
            textView.attributedText = attributedString
        }

        self.attributesArray = attributesArray
    }

    internal func setAttributedButtonTitle(with attributesArray: [Attributes], state: UIControlState) {
        let attributedString = UIView.attributedString(with: attributesArray)
        if let button = self as? UIButton {
            button.setAttributedTitle(attributedString, forState: state)
        }
        self.attributesArray = attributesArray
    }
}

extension UIView {
    private static func attributedString(with attributesArray: [Attributes]) -> NSAttributedString? {
        let texts = attributesArray.map { (attributes) -> String? in
            return (attributes[kCustomAttributeDefaultText] as? String)
        }

        return updatedAttributedString(with: texts, attributesArray: attributesArray)
    }

    private static func updatedAttributedString(with texts: [String?], attributesArray: [Attributes]) -> NSAttributedString? {
        guard texts.count == attributesArray.count else {
            assertionFailure("Failed to call updatedAttributedString: `texts` & `attributesArray` should have same count.")
            return nil
        }

        let attributedStrings = attributesArray.enumerate().flatMap({ (index, attribute) -> NSAttributedString? in
            if let idx = Int(String(index)) {
                let text = texts[idx] ?? ""
                return NSAttributedString(string: text, attributes: attribute)
            }
            return nil
        })

        let attributedText = attributedString(combinedWith: attributedStrings)

        return attributedText
    }

    private static func attributedString(combinedWith attributedStrings: [NSAttributedString]) -> NSAttributedString? {
        guard let first = attributedStrings.first else {
            return nil
        }

        guard attributedStrings.count > 1 else {
            return first
        }

        return attributedStrings.reduce(first, combine: { (acc, cur) -> NSAttributedString in
            if acc == cur {
                return acc
            }

            let str = acc.mutableCopy()
            str.appendAttributedString(cur)
            return str.copy() as! NSAttributedString
        })
    }
}

internal func formattedJSON(json: JSONDictionary) -> String? {
    do {
        let data = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
        return String(data: data, encoding: NSUTF8StringEncoding)
    } catch {
        print(error)
        return nil
    }
}
