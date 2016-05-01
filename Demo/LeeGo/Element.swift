//
//  Element.swift
//  PlaygroundProject
//
//  Created by Victor WANG on 14/11/15.
//  Copyright © 2015 Le Monde. All rights reserved.
//

import Foundation

class Element {

    let elementId: Int?
    let title: String?
    let natureEdito: String?
    let description: String?
    let date: String?
    let isRestrict: Bool
    let type: String?

    init?(dictionary: [String: AnyObject]) {
        self.elementId = dictionary["id"] as? Int
        self.title = dictionary["titre"] as? String
        self.natureEdito = dictionary["nature_edito"] as? String
        self.description = dictionary["description"] as? String
        self.date = dictionary["date_publication"] as? String
        self.isRestrict = (dictionary["restreint"] as? Bool) ?? false
        self.type = dictionary["type"] as? String

        if (self.elementId == nil || self.title == nil || self.description == nil || self.date == nil || self.type == nil) {
            return nil
        }
    }
}

extension Element {

    static func elementsFromDictionaries(dictionaries: [[String: AnyObject]]) -> [Element] {
        return dictionaries.flatMap({ (dictionary) -> Element? in
            return Element(dictionary: dictionary)
        })
    }
    
}