//
//  Item.swift
//  DailyTask
//
//  Created by Makan Fofana on 11/10/18.
//  Copyright © 2018 Makan Fofana. All rights reserved.
//

import Foundation
import RealmSwift



class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
}
