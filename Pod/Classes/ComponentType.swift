//
//  ComponentType.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

protocol Configurable {
    func setupWithStyle(style: [Appearance])
    func handleCustomStyle(style: [String: AnyObject])
}

protocol Updatable {
    // func updateWithItem<Item: ItemType>(item: Item)
}

protocol Reusable {
    static var reuseIdentifier: String { get }

    func cleanUpForReuse()
}

protocol Composable {
    // typealias T: Hashable
    func compositeSubcomponents(components: [ComponentTarget], layout: Layout) -> [UIView: ComponentTarget]
}

extension Composable where Self: UIView {
    func compositeSubcomponents(components: [ComponentTarget], layout: Layout) -> [UIView: ComponentTarget] {

        var subcomponents: [UIView: ComponentTarget] = [:]
        // create subview
        var viewsDictionary = [String: UIView]()
        for component in components {
            // It seems to me that there is no way to init an instance from class in Swift, so we made it in ObjC
            if let componentView = CellComponentFactory.createCellComponentFromClass(component.targetClass, componentKey: component.name) {
                viewsDictionary[component.name] = componentView
                self.addSubview(componentView)

                // Setup each component view with style which listed in configuration
                // componentView.context.configuration = subConfig
                componentView.context.componentView = componentView
                componentView.context.isRoot = false

                subcomponents[componentView] = component
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
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: layout.metrics, views: viewsDictionary)
            for constraint in constraints {
                //constraint.priority = 990
                //constraint.shouldBeArchived = true
                constraint.identifier = constraint.description
//                print(constraint)
                self.addConstraint(constraint)
            }
        }
        return subcomponents
    }
}

extension Configurable where Self: UIView {
    func handleCustomStyle(style: [String: AnyObject]) {
        print("defaut imp")
    }
    

    func setupWithStyle(style: [Appearance]) {

        // may be improved by functional map
        var dictionary = [String: AnyObject](), customDict = [String: AnyObject]()
        for appearance in style {

            if let (key, value) = appearance.tuple() where appearance.isCustom {
                customDict[key] = value
            } else if let (_, value) = appearance.tuple() where appearance.isAttributedString {
                if let attrList = value as? NSArray, let label = self as? UILabel {
                    label.attributedText = attrList.flatMap({ (attribute) -> NSAttributedString? in
                        if let attribute = attribute as? [String : AnyObject] {
                            return NSAttributedString(string: "holder", attributes: attribute)
                        }
                        return nil
                    }).combineToAttributedString()
                }
            } else if let (key, value) = appearance.tuple() {
                dictionary[key] = value
            }
        }

        for (key, value) in dictionary {
            if self.respondsToSelector(Selector(key)) {
                self.setValue(value, forKey: key)
            } else {
                print(key)
            }
        }
        self.handleCustomStyle(customDict)
    }
}

//extension Updatable where Self: UIView {
//    func updateWithItem<Item: ItemType>(item: Item) {
//        item.updateComponent(self)
//    }
//}

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
//
//    func configure(item: ItemType, indexPath: NSIndexPath? = nil) {
//        
//    }

    final func configure<Item: ComponentDataSource>(dataSource: Item, component: ComponentTarget) {

        // resolve conf based on item?, indexPath? or others ?
        // willApply

        var shouldRebuild = false

        if let ComponentTarget = self.context.component {
            // TODO: apply diff from config & configuration
            shouldRebuild = (ComponentTarget.style != component.style)
        } else {
            shouldRebuild = true
        }

        self.context.component = component

        // setup self
        if shouldRebuild {
            setupWithStyle(component.style)
        }

        // update self
        // updateWithItem(item)
        dataSource.updateComponent(self, with: component)

        if shouldRebuild {
            // add & layout sub components
            if let components = component.components, let layout = component.layout {
                let subcomponents = compositeSubcomponents(components, layout: layout)
                for (component, componentTarget) in subcomponents {
                    component.configure(with: dataSource, componentTarget: componentTarget)
                }

                return
            }
        }

        // configure sub components recursively
        for subview in self.subviews where subview.context.componentView == subview {
            if let componentTarget = subview.context.component {
                subview.configure(with: dataSource, componentTarget: componentTarget)
            }
        }
    }
}


