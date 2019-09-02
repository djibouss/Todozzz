//
//  Item.swift
//  Todozzz
//
//  Created by Jean-Baptiste Chaubet on 02.09.19.
//  Copyright © 2019 Jean-Baptiste Chaubet. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

