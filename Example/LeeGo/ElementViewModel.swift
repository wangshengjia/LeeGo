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

    func updateComponent(component: Updatable) {
        switch component {
        case let titleLabel as ComponentTitle:
            titleLabel.text = element.title
        case let titleLabel as ComponentSubtitle:
            titleLabel.text = element.description
        default:
            print(component)
        }
    }

    func resolveConfigurationForComponent(component: ComponentType, indexPath: NSIndexPath? = nil) -> Configuration {

        return Configuration()
    }
}
