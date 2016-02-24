//
//  Responsive.swift
//  LeeGo
//
//  Created by Victor WANG on 03/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol SizeClassesType: Hashable {
    static func sizeClass(width: Double) -> Self
}

enum SizeClasses: SizeClassesType {
    case XXS, XS, S, M, L, XL, XXL
}

extension SizeClasses {
    static func sizeClass(width: Double) -> SizeClasses {
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

protocol Responsive {
    //    func responsive<S: SizeClassesType>(value: [S: Self]) -> Self
}

extension Responsive {
    func responsive(value: [SizeClasses: Self]) -> Self {
        if let responsiveValue = value[SizeClasses.sizeClass(currentWindowSize())] {
            return responsiveValue
        }
        return self
    }
    func currentWindowSize() -> Double {
        return 1
    }
}

extension Int: Responsive {
}
extension Float: Responsive {
}
extension Double: Responsive {
}

