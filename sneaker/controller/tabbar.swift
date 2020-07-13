//
//  tabbar.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit

class tabbar: UITabBarController {
    var role: String?
    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if role == "admin"{
            viewControllers?.remove(at: 1)
            viewControllers?.remove(at: 1)
            viewControllers?.remove(at: 1)
            let navvc = viewControllers![1] as! UINavigationController
            let pvc = navvc.topViewController as! profileViewController
            pvc.uusername = username!
            let navvc2 = viewControllers![0] as! UINavigationController
            let provc = navvc2.topViewController as! productViewController
            provc.role = role!
        }else if role == "customer"{
            let navvc = viewControllers![4] as! UINavigationController
            let pvc = navvc.topViewController as! profileViewController
            pvc.uusername = username!
            let navvc2 = viewControllers![0] as! UINavigationController
            let provc = navvc2.topViewController as! productViewController
            provc.role = role!
            provc.username = username!
        }
    }
}
