//
//  profileViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 01/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

class profileViewController: UIViewController {
    let realm = try! Realm()
    var uusername: String = ""
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var role: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        let users = Array(realm.objects(user.self))
        for user in users{
            if uusername == user.username{
                name.text = user.name
                username.text = user.username
                password.text = user.password
                email.text = user.email
                address.text = user.address
                role.text = user.role
            }
        }
    }
    
    
    @IBAction func settingTapped(_ sender: UIBarButtonItem) {
        let setvc = storyboard?.instantiateViewController(identifier: "settingViewController") as! settingViewController
        setvc.delegate = self
        setvc.uusername = uusername
        self.navigationController?.pushViewController(setvc, animated: true)
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        
    }
    
}

extension profileViewController: settingViewControllerDelegate{
    func didChange(_ user: user) {
        name.text = user.name
        username.text = user.username
        password.text = user.password
        email.text = user.email
        role.text = user.role
    }
}
