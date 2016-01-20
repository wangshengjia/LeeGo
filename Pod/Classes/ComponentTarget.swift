//
//  ComponentTarget.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol ComponentTargetType {
    func availableComponentTypes() -> [String : AnyClass]
}

extension ComponentTargetType {
    func componentClass() -> AnyClass? {
        return self.availableComponentTypes()[self.stringValue]
    }

    var stringValue: String {
        return String(self)
    }
}