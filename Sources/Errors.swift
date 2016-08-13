//
//  Errors.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

internal enum JSONParseError: Error {
    case unexpectedKeyError(key: String), mismatchedTypeError(type: Any.Type, expectedType: Any.Type)
}

internal enum JSONConvertibleError: Error {
    case unexpectedBrickNameError(JSONDictionary)
}
