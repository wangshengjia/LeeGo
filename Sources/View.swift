//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol ComponentDataSource: class {
    func updateComponent(componentView: UIView, with componentTarget: ComponentTarget)
}

public enum ConfigurationUpdatingStrategy {
    case WhenComponentChanged
    case Always
}

extension UIView: ComponentType {
    public func setupCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown style \(style), should implement `handleCustomStyle:` in extension of UIView or its subclass.")
    }
    public func removeCustomStyle(style: [String: AnyObject]) {
        assertionFailure("Unknown style \(style), should implement `removeCustomStyle:` in extension of UIView or its subclass.")
    }
}

extension UIView {
    
    /**
     * Configure component with configuration
     *
     - parameter componentTarget:  configuration
     - parameter dataSource:       data source
     - parameter updatingStrategy: the strategy used to decide if should rebuild a component
     */
    public func configure(componentTarget: ComponentTarget, dataSource: ComponentDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenComponentChanged) {
        if let cell = self as? UICollectionViewCell {
            cell.contentView._configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else if let cell = self as? UITableViewCell {
            cell.contentView._configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        } else {
            _configure(componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)
        }
    }

    private func _configure(componentTarget: ComponentTarget, dataSource: ComponentDataSource? = nil, updatingStrategy: ConfigurationUpdatingStrategy = .WhenComponentChanged) {

        // resolve conf based on item?, indexPath? or others ?

        // call willApply delegate method

        // apply componentTarget
        applyDiffTo(self, newConfiguration:componentTarget, dataSource: dataSource, updatingStrategy: updatingStrategy)

        // if no error, then:
        self.configuration = componentTarget

        // call didApply delegate method

        // TODO: improve this ugly implementation
        // configure sub components recursively
        for subview in self.subviews {
            if let viewName = subview.viewName,
                let components = componentTarget.components {
                    for component in components where component.name == viewName {
                        subview.configure(component, dataSource: dataSource, updatingStrategy: updatingStrategy)
                    }
            }
        }
    }
}

extension UIView {

    // TODO: how to handle clean up for reuse
    func cleanUpForReuse() {
        switch self {
        case let label as UILabel:
            label.text = nil
        case let imageView as UIImageView:
            imageView.image = nil
        default:
            break
        }

        // do clean up
        for case let subview in self.subviews {
            subview.cleanUpForReuse()
        }
    }

    public var name: String? {
        get {
            if let name = self.componentName {
                return name
            } else {
                return self.viewName
            }
        }
    }
}


//extension UILabel {
//    override func cleanUpForReuse() {
//        self.text = nil
//    }
//}
//
//extension UIImageView {
//    override func cleanUpForReuse() {
//        self.image = nil
//    }
//}

