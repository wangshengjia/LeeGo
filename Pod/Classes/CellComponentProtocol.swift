//
//  CellComponentProtocol.swift
//  BearBeers
//
//  Created by Victor WANG on 14/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

protocol CellComponentProtocol: NSObjectProtocol {
    var componentKey: String { get }

    init(componentKey: String)

    func setup(item: AnyObject, style: [String:AnyObject])
    func update(item: AnyObject)
    func cleanUp()
}
