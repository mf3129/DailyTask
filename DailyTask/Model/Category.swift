//
//  Category.swift
//  DailyTask
//
//  Created by Makan Fofana on 11/10/18.
//  Copyright © 2018 Makan Fofana. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    
   @objc dynamic var name = ""
   @objc dynamic var Color = ""

    let items = List<Item>()
    
}
