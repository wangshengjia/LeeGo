//
//  ComponentType.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol Configurable {
    func setupWithStyle(style: StyleType)
}

public protocol Updatable {
    func updateWithItem(item: ItemType)
}

public protocol Reusable {
    static var reuseIdentifier: String { get }

    func cleanUpForReuse()
}

public protocol Composable {
    func compositeSubcomponents(components: [ComponentTarget: ConfigurationType], layout: Layout)
}

extension Composable where Self: UIView {
    public func compositeSubcomponents(components: [ComponentTarget: ConfigurationType], layout: Layout) {
        // create subview
        var viewsDictionary = [String: UIView]()
        for (component, subConfig) in components ?? [:] {
            // It seems to me that there is no way to init an instance from class in Swift, so we made it in ObjC
            if let componentView = CellComponentFactory.createCellComponentFromClass(component.targetClass, componentKey: component.name) {
                viewsDictionary[component.name] = componentView
                self.addSubview(componentView)

                // Setup each component view with style which listed in configuration
                componentView.componentViewModel.configuration = subConfig
                componentView.componentViewModel.componentView = componentView
            }
        }

        // apply diff, update the part only if changed
        /*
        for case let subview as Configurable in self.subviews {
        subview.setupWithConfiguration(configuration)
        }
        */

        // Layout each component view with auto layout visual format language from configuration.
        for format in layout.formats {
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: layout.metrics, views: viewsDictionary))
        }
    }
}

extension Configurable where Self: UIView {
    final public func setupWithStyle(style: StyleType) {
        self.setValuesForKeysWithDictionary(style.rawStyle())
    }
}

extension Updatable where Self: UIView {
    final public func updateWithItem(item: ItemType) {
        item.updateComponent(self)

        /*
        for case let subview as Updatable in self.subviews {
        subview.updateWithItem(item)
        }*/
    }
}

extension Reusable where Self: UIView {
    public static var reuseIdentifier: String {
        // I like to use the class's name as an identifier
        // so this makes a decent default value.
        return String(Self)
    }

    final public func cleanUpForReuse() {

        // do clean up

        for case let subview as Reusable in self.subviews {
            subview.cleanUpForReuse()
        }
    }
}

extension ComponentType where Self: UIView {

    public func configure(item: ItemType, indexPath: NSIndexPath? = nil) {
        
    }

    public final func configure(item: ItemType, configuration: ConfigurationType) {

        // resolve conf based on item?, indexPath? or others ?

        if let _ = self.componentViewModel.configuration {
            // apply diff from config & configuration
        } else {
            self.componentViewModel.configuration = configuration
        }

        // setup self
        if shouldSetup() {
            self.removeConstraints(self.constraints)
            self.subviews.forEach({ (subview) -> () in
                subview.removeFromSuperview()
            })
            setupWithStyle(configuration.style)
        }

        // update self
        updateWithItem(item)

        // add & layout sub components
        if let components = configuration.components, let layout = configuration.layout {
            compositeSubcomponents(components, layout: layout)
        }

        // configure sub components recursively
        for subview in self.subviews where subview.componentViewModel.componentView == subview {
            if let config = subview.componentViewModel.configuration {
                subview.configure(item, configuration: config)
            }
        }
    }

    public final func shouldSetup() -> Bool {
        return true
    }
}


