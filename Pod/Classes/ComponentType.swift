//
//  ComponentType.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol Configurable {
    func setupWithStyle(style: [Appearance: AnyObject])
    func handleCustomStyle(style: [String: AnyObject])
}

protocol Updatable {
    func updateWithItem<Item: ItemType>(item: Item)
}

protocol Reusable {
    static var reuseIdentifier: String { get }

    func cleanUpForReuse()
}

protocol Composable {
    // typealias T: Hashable
    // func compositeSubcomponents(components: [ComponentTarget<T>: Configuration<T>], layout: Layout) -> [UIView: Configuration<T>]
}

extension Composable where Self: UIView {
    func compositeSubcomponents(components: [ComponentTarget: Configuration], layout: Layout) -> [UIView: Configuration] {

        var subcomponents: [UIView: Configuration] = [:]
        // create subview
        var viewsDictionary = [String: UIView]()
        for (component, subConfig) in components ?? [:] {
            // It seems to me that there is no way to init an instance from class in Swift, so we made it in ObjC
            if let componentView = CellComponentFactory.createCellComponentFromClass(component.targetClass, componentKey: component.name) {
                viewsDictionary[component.name] = componentView
                self.addSubview(componentView)

                // Setup each component view with style which listed in configuration
                // componentView.context.configuration = subConfig
                componentView.context.name = component.name
                componentView.context.componentView = componentView
                componentView.context.isRoot = false
                subcomponents[componentView] = subConfig
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

        return subcomponents
    }
}

extension Configurable where Self: UIView {
    func handleCustomStyle(style: [String: AnyObject]) {
        print("defaut imp")
    }
    

    func setupWithStyle(style: [Appearance: AnyObject]) {

        // may be improved by functional map
        var dictionary = [String: AnyObject](), customDict = [String: AnyObject]()
        for (appearance, value) in style {
            if case let .Custom(customAppearance) = appearance {
                customDict[customAppearance] = value
            } else if appearance == .attributedString {
                if let attrList = value as? NSArray, let label = self as? UILabel {
                    label.attributedText = attrList.flatMap({ (attribute) -> NSAttributedString? in
                        if let attribute = attribute as? [String : AnyObject] {
                            return NSAttributedString(string: "holder", attributes: attribute)
                        }
                        return nil
                    }).combineToAttributedString()
                }
            } else {
                dictionary[String(appearance)] = value
            }
        }

        // delegate?.component:self setCustomAppearance:customDict
        self.setValuesForKeysWithDictionary(dictionary)
        self.handleCustomStyle(customDict)
    }
}

extension Updatable where Self: UIView {
    func updateWithItem<Item: ItemType>(item: Item) {
        item.updateComponent(self)

        /*
        for case let subview as Updatable in self.subviews {
        subview.updateWithItem(item)
        }*/
    }
}

extension Reusable where Self: UIView {
    static var reuseIdentifier: String {
        // I like to use the class's name as an identifier
        // so this makes a decent default value.
        return String(Self)
    }

    final func cleanUpForReuse() {

        // do clean up

        for case let subview as Reusable in self.subviews {
            subview.cleanUpForReuse()
        }
    }
}

protocol ComponentType: Configurable, Composable, Updatable, Reusable {
    // var configuration: ConfigurationType { get }
}

extension ComponentType where Self: UIView {

    func configure(item: ItemType, indexPath: NSIndexPath? = nil) {
        
    }

    final func configure<Item: ItemType>(item: Item, configuration: Configuration) {

        // resolve conf based on item?, indexPath? or others ?
        // willApply

        var shouldRebuild = false

        if let config = self.context.configuration {
            // apply diff from config & configuration
            for (key, value) in config.style {
                guard let newValue = configuration.style[key] else {
                    shouldRebuild = true
                    break
                }
                if !newValue.isEqual(value) {
                    shouldRebuild = true
                    break
                }
            }
        } else {
            shouldRebuild = true
            self.context.configuration = configuration
        }

        // setup self
        if shouldRebuild {
            setupWithStyle(configuration.style)
        }

        // update self
        updateWithItem(item)

        if shouldRebuild {
            // add & layout sub components
            if let components = configuration.components, let layout = configuration.layout {
                let subcomponents = compositeSubcomponents(components, layout: layout)
                for (component, config) in subcomponents {
                    component.configure(item, configuration: config)
                }

                return
            }
        }

        // configure sub components recursively
        for subview in self.subviews where subview.context.componentView == subview {
            if let config = subview.context.configuration {
                subview.configure(item, configuration: config)
            }
        }
    }
}


