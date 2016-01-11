//
//  ReusableCollectionViewCell.swift
//  BearBeers
//
//  Created by Victor WANG on 14/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//


public class ReusableCollectionViewCell : UICollectionViewCell {

    func configureWithItem(item: AnyObject) {
//        switch item.dynamicType {
//
//        default:
//            self.backgroundColor = UIColor.whiteColor()
//        }
    }

    public func configureWithItem(item: AnyObject, reuseIdentifier: String) {
        if shouldSetupCell() {
            setupCellWithItem(item, reuseIdentifier: reuseIdentifier)
        } else {
            for subview in self.contentView.subviews {
                (subview as? CellComponentProtocol)?.update(item)
            }
        }
        self.backgroundColor = UIColor.whiteColor()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        for subview in self.contentView.subviews {
            (subview as? CellComponentProtocol)?.cleanUp()
        }
    }

    func shouldSetupCell() -> Bool {
        return self.contentView.subviews.count == 0
    }

    func setupCellWithItem(item: AnyObject, reuseIdentifier: String) {
        // Retrieve configuration correctly based on reuse identification
        guard let configuration = Configurations.CellConfigurationWithReuseIdentifier(reuseIdentifier),
            let componentKeys = configuration[Configurations.CellKeys.components] as? Array<String>,
            let componentStyles = configuration[Configurations.CellKeys.styles]  as? Array<Dictionary<String,AnyObject>> else {
                print("Cell configuration for \(reuseIdentifier) not found or not correct")
                return
        }

        var viewsDictionary = [String: UIView]()
        // Instantiate each component view based on class which listed in configuration.
        for (index, componentKey) in componentKeys.enumerate() {
            if let componentClass = Configurations.ComponentClasses[componentKey] as? CellComponentProtocol.Type {
                // It seems to that there is no way to init an intance from class in Swift, so I make it in ObjC
                let view = CellComponentFactory.createCellComponentFromClass(componentClass, componentKey: componentKey)
                viewsDictionary[componentKey] = view
                self.contentView.addSubview(view)
                // Setup each component view with style which listed in configuration
                (view as! CellComponentProtocol).setup(item, style: componentStyles[index])
            }
        }

        // Layout each component view with auto layout visual format language from configuration.
        if let visualFormats = configuration[Configurations.CellKeys.layout] as? Array<String>,
            let visualMetrics = configuration[Configurations.CellKeys.metrics] as? Dictionary<String, AnyObject>{
                for format in visualFormats {
                    self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: visualMetrics, views: viewsDictionary))
                }
        }
    }
}