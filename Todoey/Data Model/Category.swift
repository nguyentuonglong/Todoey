//
//  Category.swift
//  Todoey
//
//  Created by Long Nguyen on 1/25/19.
//  Copyright © 2019 Long Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
