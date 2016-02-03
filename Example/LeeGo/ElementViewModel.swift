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
        case let titleLabel as UILabel where component.name() == ComponentProvider.title.rawValue:
            titleLabel.setAttributeString(with: [
                Styles.marker: element.isRestrict ? "󰀀" : "",
                Styles.customTitle: element.title ?? "",
                Styles.nature: element.natureEdito ?? ""
                ])

        case let subtitleLabel as UILabel  where component.name() == ComponentProvider.subtitle.rawValue:
            subtitleLabel.text = element.description
        case let avatar as UIImageView where component.name() == ComponentProvider.avatar.rawValue:
            avatar.backgroundColor = UIColor.grayColor()
        default:
            break
        }
    }
}
