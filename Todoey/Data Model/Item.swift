//
//  Item.swift
//  Todoey
//
//  Created by Long Nguyen on 1/25/19.
//  Copyright © 2019 Long Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done :  Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var dateCreated : Date = Date()
}
