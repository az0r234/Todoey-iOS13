//
//  Category.swift
//  Todoey
//
//  Created by Alok Acharya on 3/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var colorVal:String = ""
    let items = List<Item>()
}
