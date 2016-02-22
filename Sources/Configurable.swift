//
//  Configurable.swift
//  Pods
//
//  Created by Victor WANG on 21/02/16.
//
//

import Foundation

protocol Configurable {
    func setup<Component: UIView>(component: Component, currentStyle: [Appearance], newStyle: [Appearance])
    func setupCustomStyle(style: [String: AnyObject])
    func removeCustomStyle(style: [String: AnyObject])
}


extension Configurable {

    func setup<Component: UIView>(component: Component, currentStyle: [Appearance] = [], newStyle: [Appearance]) {

        // if current appearance not appeared in new style, then set them to default value
        for old in currentStyle where !newStyle.contains(old) {
            old.apply(to: component, useDefaultValue: true)
        }

        for appearance in newStyle {
            appearance.apply(to: component)
        }
    }
}