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

extension ComponentTarget {
    func article() {
        UIView().configure(
            ComponentBuilder.title.componentTarget()
                .flowH(ComponentBuilder.subtitle.componentTarget(), metrics: ComponentBuilder.defaultMetrics)
                .flowV(ComponentBuilder.avatar.componentTarget(), metrics: ComponentBuilder.defaultMetrics)
        )

    }

    func flowH(c1: ComponentTarget, metrics: MetricsValuesType) -> ComponentTarget {
        return ComponentTarget(name: "inlineview", targetClass: UIView.self).style([.translatesAutoresizingMaskIntoConstraints(false), .backgroundColor(UIColor.clearColor())]).components(self, c1, layout: { (name1, name2) -> Layout in
            return Layout([
                "H:|-left-[\(name1)]-interspaceH-[\(name2)]-right-|",
                "V:|[\(name1)]-interspaceV-[\(name2)]|"], metrics)
        })
    }

    func flowV(c1: ComponentTarget, metrics: MetricsValuesType) -> ComponentTarget {
        return ComponentTarget(name: "inlineview", targetClass: UIView.self).style([.translatesAutoresizingMaskIntoConstraints(false), .backgroundColor(UIColor.clearColor())]).components(self, c1, layout: { (name1, name2) -> Layout in
            return Layout([
                "H:|[\(name1)]-interspaceH-[\(name2)]|",
                "V:|-top-[\(name1)]-interspaceV-[\(name2)]-bottom-|"], metrics)
        })
    }
}

// print("a".f1("b").f2("c", "d").f1("e"))