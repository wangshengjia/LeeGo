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
        case Dimension, SubviewsLayout, Ratio, Unknown
    }

    internal func lg_setIdentifier(with type: Mode) {
        switch type {
        case .Dimension:
            self.identifier = "LG_Dimension: \(self.description)"
        case .SubviewsLayout:
            self.identifier = "LG_SubviewsLayout: \(self.description)"
        case .Ratio:
            self.identifier = "LG_Ratio: \(self.description)"
        default:
            return
        }
    }

    internal var mode: Mode {
        if self.identifier?.hasPrefix("LG_Dimension") ?? false {
            return .Dimension
        } else if self.identifier?.hasPrefix("LG_SubviewsLayout") ?? false {
            return .SubviewsLayout
        } else if self.identifier?.hasPrefix("LG_Ratio") ?? false {
            return .Ratio
        } else {
            return .Unknown
        }
    }
}

extension UIView {

    internal func lg_constraint(type: NSLayoutAttribute) -> NSLayoutConstraint? {
        switch type {
        case .Width, .Height:
            for constraint in self.constraints where constraint.firstAttribute == type
                && constraint.mode == .Dimension
                && constraint.firstItem === self
                && constraint.secondItem === nil {
                    return constraint
            }
        default:
            break
        }

        return nil
    }

    internal func lg_applyConstraint(type: NSLayoutAttribute, constant: CGFloat) {
        if let constraint = self.lg_constraint(type) {
            constraint.constant = constant
        } else {
            let constraint = NSLayoutConstraint(item: self, attribute: type, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
            constraint.lg_setIdentifier(with: .Dimension)
            self.addConstraint(constraint)
        }
    }

    internal func unapplyConstraint(type: NSLayoutAttribute) {
        if let constraint = self.lg_constraint(type) {
            self.removeConstraint(constraint)
        }
    }
}