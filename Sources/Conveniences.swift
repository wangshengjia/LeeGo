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

    internal func filter(includeElement: (Key, Value) throws -> Bool) rethrows -> Dictionary {
        var result = self
        for (key, value) in result {
            if try !includeElement(key, value) {
                result.removeValue(forKey: key)
            }
        }
        return result
    }
}

extension Dictionary {

    internal func parse<T>(_ key: JSONKeyType) throws -> T {
        return try parse(key.asString)
    }

    internal func parse<T>(_ key: String) throws -> T {
        if let value = self[key as! Key] {
            if let valueWithExpectedType = value as? T {
                return valueWithExpectedType
            } else {
                throw JSONParseError.mismatchedTypeError(type: type(of: value), expectedType: T.self)
            }
        } else {
            throw JSONParseError.unexpectedKeyError(key: key)
        }
    }

    internal func parse<T>(_ key: JSONKeyType, _ defaultValue: T) -> T {
        return parse(key.asString, defaultValue)
    }

    internal func parse<T>(_ key: String, _ defaultValue: T) -> T {
        if let value = self[key as! Key] as? T {
            return value
        }

        return defaultValue
    }
}

// MARK: NSAttributedString

public let kCustomAttributeDefaultText = "kCustomAttributeDefaultText"

extension UILabel {
    public func lg_updatedAttributedString(with texts: [String?]) -> NSAttributedString? {
        return UIView.lg_updatedAttributedString(with: texts, attributesArray: attributesArray)
    }
}

extension UITextField {
    public func lg_updatedAttributedString(with texts: [String?]) -> NSAttributedString? {
        return UIView.lg_updatedAttributedString(with: texts, attributesArray: attributesArray)
    }
}

extension UITextView {
    public func lg_updatedAttributedString(with texts: [String?]) -> NSAttributedString? {
        return UIView.lg_updatedAttributedString(with: texts, attributesArray: attributesArray)
    }
}

extension UIView {

    internal func lg_setAttributedString(with attributesArray: [Attributes]) {
        let attributedString = UIView.lg_attributedString(with: attributesArray)

        if let label = self as? UILabel {
            label.attributedText = attributedString
        } else if let textField = self as? UITextField {
            textField.attributedText = attributedString
        } else if let textView = self as? UITextView {
            textView.attributedText = attributedString
        }

        self.attributesArray = attributesArray
    }

    internal func lg_setAttributedButtonTitle(with attributesArray: [Attributes], state: UIControlState) {
        let attributedString = UIView.lg_attributedString(with: attributesArray)
        if let button = self as? UIButton {
            button.setAttributedTitle(attributedString, for: state)
        }
        self.attributesArray = attributesArray
    }
}

extension UIView {
    fileprivate static func lg_attributedString(with attributesArray: [Attributes]) -> NSAttributedString? {
        let texts = attributesArray.map { (attributes) -> String? in
            return (attributes[kCustomAttributeDefaultText] as? String)
        }

        return lg_updatedAttributedString(with: texts, attributesArray: attributesArray)
    }

    fileprivate static func lg_updatedAttributedString(with texts: [String?], attributesArray: [Attributes]) -> NSAttributedString? {
        guard texts.count == attributesArray.count else {
            assertionFailure("Failed to call updatedAttributedString: `texts` & `attributesArray` should have same count.")
            return nil
        }

        let attributedStrings = attributesArray.enumerated().flatMap({ (index, attribute) -> NSAttributedString? in
            if let idx = Int(String(index)) {
                let text = texts[idx] ?? ""
                return NSAttributedString(string: text, attributes: attribute)
            }
            return nil
        })

        let attributedText = lg_attributedString(combinedWith: attributedStrings)

        return attributedText
    }

    private static func lg_attributedString(combinedWith attributedStrings: [NSAttributedString]) -> NSAttributedString? {
        guard let first = attributedStrings.first else {
            return nil
        }

        guard attributedStrings.count > 1 else {
            return first
        }

        return attributedStrings.reduce(first, { (acc, cur) -> NSAttributedString in
            if acc == cur {
                return acc
            }

            let str = acc.mutableCopy() as? NSMutableAttributedString
            str?.append(cur)
            return str?.copy() as! NSAttributedString
        })
    }
}

public func formattedStringFromJSON(_ json: JSONDictionary) -> String? {
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return String(data: data, encoding: String.Encoding.utf8)
    } catch {
        print(error)
        return nil
    }
}
