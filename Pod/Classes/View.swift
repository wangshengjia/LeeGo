//
//  View.swift
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
    func compositeSubcomponents(components: [(ComponentTargetType, ConfigurationType)], layout: Layout)
}

extension Composable where Self: UIView {
    public func compositeSubcomponents(components: [(ComponentTargetType, ConfigurationType)], layout: Layout) {
        // create subview
        var viewsDictionary = [String: UIView]()
        for (component, subConfig) in components ?? [] {
            if let componentClass = component.componentClass() {
                // It seems to me that there is no way to init an instance from class in Swift, so we made it in ObjC
                if let componentView = CellComponentFactory.createCellComponentFromClass(componentClass, componentKey: component.stringValue) {
                    viewsDictionary[component.stringValue] = componentView
                    self.addSubview(componentView)

                    // Setup each component view with style which listed in configuration
                    componentView.componentViewModel?.configuration = subConfig
                }
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

public protocol ComponentViewModelType {

}

public final class ComponentViewModel: ComponentViewModelType {
    var componentView: UIView? = nil
    var configuration: ConfigurationType?

    init() {

    }
}

extension UIView: ComponentType {
    private struct AssociatedKeys {
        static var ComponentViewModelName = "componentViewModel_name"
    }

    private var componentViewModel: ComponentViewModel? {
        get {
            if let viewModel = objc_getAssociatedObject(self, &AssociatedKeys.ComponentViewModelName) as? ComponentViewModel {
                return viewModel
            } else {
                let viewModel = ComponentViewModel()
                viewModel.componentView = self
                objc_setAssociatedObject(self, &AssociatedKeys.ComponentViewModelName, viewModel as ComponentViewModel?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return viewModel
            }
        }
    }
}

extension ComponentType where Self: UIView {

    public final func configure(item: ItemType, configuration: ConfigurationType) {

        if let _ = self.componentViewModel?.configuration {
            // apply diff from config & configuration
        } else {
            self.componentViewModel?.configuration = configuration
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
        for subview in self.subviews {
            if let config = subview.componentViewModel?.configuration {
                subview.configure(item, configuration: config)
            }
        }
    }
    
    public final func shouldSetup() -> Bool {
        return true
    }
}