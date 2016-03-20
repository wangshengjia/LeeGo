//
//  Icon.swift
//  LeeGo
//
//  Created by Victor WANG on 11/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import UIKit


protocol Animatable {

}

extension Animatable where Self: UIView {

    func fadeInFadeOut(duration: Double) {
        self.alpha = 1.0
        UIView.animateWithDuration(duration, delay: 0, options: .Autoreverse, animations: { () -> Void in
            self.alpha = 0.0
            }) { (finished) -> Void in
                self.fadeInFadeOut(duration)
        }
    }
}

class Icon: UIImageView, Animatable {
    let duration = 1.0

    override func componentDidAwake() {
        super.componentDidAwake()
        
        fadeInFadeOut(duration)
    }
}