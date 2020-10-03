

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var colorVal:String = ""
    let items = List<Item>()
}
