//
//  DetailsViewController.swift
//  LeeGo
//
//  Created by Victor WANG on 08/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import UIKit
import LeeGo

class DetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.configure(ComponentTarget(name: "details", targetClass: UIView.self)
            .components(ComponentBuilder.detailsView.componentTarget(), layout: { details -> Layout in
                Layout(["H:|[detailsView]|", "V:|[detailsView]|"])
            }))
    }

}

extension String {
    func f1(a: String) -> String {
        return self + a
    }

    func f2(a: String, _ b: String) -> String {
        return self + a + b
    }
}

// print("a".f1("b").f2("c", "d").f1("e"))