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

    weak var button: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.configure(ComponentTarget.container(within: ComponentBuilder.detailsView.componentTarget()))

        self.button = self.view.viewForOutletKey("favoriteButton") as? UIButton
        self.button?.addTarget(self, action: "tap:", forControlEvents: .TouchUpInside)

    }

    func tap(button: UIButton) {
        print("tap")
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