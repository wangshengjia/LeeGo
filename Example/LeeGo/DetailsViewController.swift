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

class DetailsViewController: UIViewController, ComponentDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.configure(with: self, componentTarget: ComponentProvider.detailsView.componentTarget()!)
        
    }

    // MARK: ComponentDataSource

    func updateComponent(componentView: UIView, with componentTarget: ComponentTarget) {
        
    }
}