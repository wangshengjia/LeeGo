//
//  Constraint.swift
//  LeeGo
//
//  Created by Victor WANG on 19/03/16.
//
//

import Foundation

extension NSLayoutConstraint {
    internal enum Mode {
        case dimension, subviewsLayout, ratio, unknown
    }

    internal func lg_setIdentifier(with type: Mode) {
        switch type {
        case .dimension:
            self.identifier = "LG_Dimension: \(self.description)"
        case .subviewsLayout:
            self.identifier = "LG_SubviewsLayout: \(self.description)"
        case .ratio:
            self.identifier = "LG_Ratio: \(self.description)"
        default:
            return
        }
    }

    internal var mode: Mode {
        if self.identifier?.hasPrefix("LG_Dimension") ?? false {
            return .dimension
        } else if self.identifier?.hasPrefix("LG_SubviewsLayout") ?? false {
            return .subviewsLayout
        } else if self.identifier?.hasPrefix("LG_Ratio") ?? false {
            return .ratio
        } else {
            return .unknown
        }
    }
}

extension UIView {

    internal func lg_constraint(_ type: NSLayoutAttribute) -> NSLayoutConstraint? {
        switch type {
        case .width, .height:
            for constraint in self.constraints where constraint.firstAttribute == type
                && constraint.mode == .dimension
                && constraint.firstItem === self
                && constraint.secondItem === nil {
                    return constraint
            }
        default:
            break
        }

        return nil
    }

    internal func lg_applyConstraint(_ type: NSLayoutAttribute, constant: CGFloat) {
        if let constraint = self.lg_constraint(type) {
            constraint.constant = constant
        } else {
            let constraint = NSLayoutConstraint(item: self, attribute: type, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
            constraint.lg_setIdentifier(with: .dimension)
            self.addConstraint(constraint)
        }
    }

    internal func unapplyConstraint(_ type: NSLayoutAttribute) {
        if let constraint = self.lg_constraint(type) {
            self.removeConstraint(constraint)
        }
    }
}
