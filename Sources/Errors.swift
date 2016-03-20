//
//  Errors.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

enum JSONParseError: ErrorType {
    case UnexpectedKeyError, MismatchedTypeError
}


enum NetworkingError: ErrorType {
    case JsonSerializationError
}