//
//  DetailsViewController.swift
//  LeeGo
//
//  Created by Victor WANG on 08/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import LeeGo

class DetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.configure(with: DetailViewModel(), componentTarget: ComponentProvider.detailsView.componentTarget()!)
    }
}

struct DetailViewModel: ItemType {
    func updateComponent(component: UIView) {
        switch component {
        case let titleLabel as UILabel where component.name() == String(ComponentProvider.title):
            titleLabel.setAttributeString(with: [
                Style.customTitle: "test",
                ])
        case let avatar as UIImageView where component.name() == String(ComponentProvider.avatar):
            avatar.backgroundColor = UIColor.grayColor()
        default:
            break
        }
    }
}