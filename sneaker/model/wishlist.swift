//
//  wishlist.swift
//  sneaker
//
//  Created by Kenneth Sim on 10/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class wishlist: Object{
    @objc dynamic var name: String?
    @objc dynamic var price: Double = 0.0
    @objc dynamic var username: String?
    
    init(name: String, price: Double, username: String){
        self.name = name
        self.price = price
        self.username = username
    }
    
    required init() {
    }
    
}
