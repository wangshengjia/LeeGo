//
//  Errors.swift
//  LeeGo
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

enum JSONParseError: ErrorType {
    case UnexpectedKeyError(key: String), MismatchedTypeError(type: Any.Type, expectedType: Any.Type)
}

enum JSONConvertibleError: ErrorType {
    case UnexpectedBrickNameError(JSONDictionary)
}