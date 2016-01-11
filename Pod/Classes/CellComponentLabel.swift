//
//  CellComponentLabel.swift
//  BearBeers
//
//  Created by Victor WANG on 15/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

extension CellComponentProtocol where Self: UILabel {
    func setup(item: AnyObject, style: [String:AnyObject]) {
        self.setValuesForKeysWithDictionary(style)

        update(item)
    }
}

public class CellComponentLabel : UILabel, CellComponentProtocol {
    let componentKey: String

    required public init(componentKey: String) {
        self.componentKey = componentKey
        super.init(frame: CGRectZero)

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required public init?(coder aDecoder: NSCoder) {
        self.componentKey = ""
        fatalError("Should use initWithComponentKey")
    }

//    func setup(item: AnyObject, style: [String:AnyObject]) {
//        self.setValuesForKeysWithDictionary(style)
//
//        update(item)
//    }

    func update(item: AnyObject) {
//        guard let element = item as? Element else {
//            assert(false, "can't handle item \(item) type")
//            return
//        }
//
//        switch componentKey {
//        case Configurations.Component.title:
//            self.text = "id: \(element.elementId)"
//        case Configurations.Component.subtitle:
//            self.text = "This is description"
//        case Configurations.Component.date:
//            self.text = "publication date"
//        default:
//            assert(false, "can't handle with component key: \(componentKey)")
//        }
    }

    func cleanUp() {
        self.text = nil
    }
}