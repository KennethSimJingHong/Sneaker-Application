//
//  user.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class user: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var role: String = ""
    
    init(name: String, username: String, password: String, email: String, address: String, role: String){
        self.name = name
        self.username = username
        self.password = password
        self.email = email
        self.address = address
        self.role = role
    }
    
    required init(){}
}
