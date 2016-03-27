//
//  Responsive.swift
//  LeeGo
//
//  Created by Victor WANG on 03/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import UIKit

// Client

enum SizeClasses: SizeClassesType {
    case XXS, XS, S, M, L, XL, XXL
}

extension SizeClasses {
    static func sizeClass(width: CGFloat) -> SizeClasses {
        switch width {
        case 1..<300:
            return .XXS
        case 300..<400:
            return .XS
        case 400..<500:
            return .S
        case 500..<650:
            return .M
        case 650..<850:
            return .L
        case 850..<1025:
            return .XL
        case _ where width >= 1025:
            return .XXL
        default:
            assertionFailure("Unhandled size classes with width: \(width)")
            return .XS
        }
    }
}

extension Int: Responsive {
    func register(type: SizeClasses) {}
}

//extension Float: Responsive {}
//extension Double: Responsive {}

extension CGFloat: Responsive {
    func register(type: SizeClasses) {
        12.responsive([.XS: 10])
    }
}

// API

protocol SizeClassesType: Hashable {
    static func sizeClass(width: CGFloat) -> Self
}

protocol Responsive {
    associatedtype R: SizeClassesType
    func register(type: R)
    func responsive(value: [R: Self]) -> Self
}

extension Responsive {
    func register(type: R) {

    }

    func responsive(value: [R: Self]) -> Self {
        if let responsiveValue = value[R.sizeClass(currentWindowSize())] {
            return responsiveValue
        }
        return self
    }

    func currentWindowSize() -> CGFloat {
        return 1
    }
}

