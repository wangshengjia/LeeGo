//
//  Errors.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

internal enum JSONParseError: ErrorType {
    case UnexpectedKeyError(key: String), MismatchedTypeError(type: Any.Type, expectedType: Any.Type)
}

internal enum JSONConvertibleError: ErrorType {
    case UnexpectedBrickNameError(JSONDictionary)
}