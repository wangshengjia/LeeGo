//
//  ElementViewModel.swift
//  LeeGo
//
//  Created by Victor WANG on 17/01/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import LeeGo

final class ElementViewModel<E: Element> {

    let element: E

    init(element: E) {
        self.element = element
    }
}

extension ElementViewModel {
    static func elementViewModelsWithElements(elements: [E]) -> [ElementViewModel] {
        return elements.map({ (element) -> ElementViewModel in
            return ElementViewModel(element: element)
        })
    }
}

extension ElementViewModel: ComponentDataSource {
    func updateComponent(componentView: UIView, with componentTarget: ComponentTarget) {
        switch componentView {
        case let titleLabel as UILabel where componentView.name == String(ComponentBuilder.title):
            titleLabel.setAttributeString(with: [
                Style.marker: element.isRestrict ? "󰀀" : "",
                Style.customTitle: element.title ?? "",
                Style.nature: element.natureEdito ?? ""
                ])

        case let subtitleLabel as UILabel  where componentView.name == String(ComponentBuilder.subtitle):
            subtitleLabel.text = element.description
        case let avatar as UIImageView where componentView.name == String(ComponentBuilder.avatar):
            avatar.backgroundColor = UIColor.grayColor()
        default:
            break
        }
    }
}
