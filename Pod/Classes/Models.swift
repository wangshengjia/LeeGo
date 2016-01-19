//
//  Models.swift
//  Pods
//
//  Created by Victor WANG on 18/01/16.
//
//

import Foundation

// Model

public protocol ItemType {
    func updateComponent(component: Updatable)
}

public struct ItemViewModel {
    public init() {}
} // should be implemented by client

extension ItemViewModel: ItemType {

    public func updateComponent(component: Updatable) {
        switch component {
        case let titleLabel as ComponentTitle:
            titleLabel.text = ""
        default:
            print("")
        }
    }
}