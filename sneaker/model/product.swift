//
//  product.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class product: Object{
    @objc dynamic var name: String?
    @objc dynamic var price: Double = 0.0
    @objc dynamic var desc: String?
    @objc dynamic var sizes: String?
    
    init(name: String, price: Double, desc: String, sizes: String){
        self.name = name
        self.price = price
        self.desc = desc
        self.sizes = sizes
    }
    
    required init() {
    }
    
}
