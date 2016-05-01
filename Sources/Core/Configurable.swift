//
//  Configurable.swift
//  LeeGo
//
//  Created by Victor WANG on 21/02/16.
//
//

import Foundation

protocol Configurable {
    func setup<View: UIView>(view: View, currentStyle: [Appearance], newStyle: [Appearance])

    func lg_setupCustomStyle(style: [String: AnyObject])
    func lg_removeCustomStyle(style: [String: AnyObject])
}


extension Configurable {

    internal func setup<View: UIView>(view: View, currentStyle: [Appearance] = [], newStyle: [Appearance]) {

        // if current appearance do not appeare in new style, then set them to default value
        // TODO: change style from Array to Set to gain some performance
        for old in currentStyle where !newStyle.contains(old) {
            old.apply(to: view, useDefaultValue: true)
        }

        for appearance in newStyle {
            appearance.apply(to: view)
        }
    }
}