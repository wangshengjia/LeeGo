//
//  ElementViewModel.swift
//  LeeGo
//
//  Created by Victor WANG on 17/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
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

extension ElementViewModel: ItemType {
    func updateComponent<Component: UIView>(component: Component) {
        switch component {
        case let titleLabel as UILabel where component.name() == String(ComponentProvider.title):
            titleLabel.setAttributeString(with: [
                Style.marker: element.isRestrict ? "󰀀" : "",
                Style.customTitle: element.title ?? "",
                Style.nature: element.natureEdito ?? ""
                ])

        case let subtitleLabel as UILabel  where component.name() == String(ComponentProvider.subtitle):
            subtitleLabel.text = element.description
        case let avatar as UIImageView where component.name() == String(ComponentProvider.avatar):
            avatar.backgroundColor = UIColor.grayColor()
        default:
            break
        }
    }
}
