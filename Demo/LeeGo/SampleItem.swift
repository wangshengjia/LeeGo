//
//  SampleItem.swift
//  LeeGo
//
//  Created by Victor WANG on 31/03/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import LeeGo

struct SampleItem {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension SampleItem: BrickDataSource {

    func update(targetView: UIView, with brick: Brick) {
        switch targetView {
        case let label as UILabel where brick == SimpleShowcase.title:
            label.text = self.title
        case let label as UILabel where brick == SimpleShowcase.description:
            label.text = self.description
        default:
            break
        }
    }
}