//
//  loginViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

class loginViewController: UIViewController {
    let realm = try! Realm()
    var users = [user]()
    var role: String? //based on role to show different vc
    var username: String? // to link all vc
    @IBOutlet weak var usernameTF: theTextField!
    @IBOutlet weak var passwordTF: theTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        users = Array(realm.objects(user.self))
        let checking = adminacc()
        
        //create an admin account if it does not exist
        if checking == false{
            let admin = user(name: "Kenneth", username: "admin123", password: "admin123", email: "kenneth@gmail.com", address: "lot1234", role: "admin")
            do{
                try realm.write{
                    realm.add(admin)
                }
            }catch{
                print("Error: \(error)")
            }
        }
    }
    
    //checking the existance of admin account
    func adminacc() -> Bool{
        for user in users{
            if user.role == "admin"{
                return true
            }
        }
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
         users = Array(realm.objects(user.self))
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        var validation: Int?
        for user in users{
            if user.username == usernameTF.text! && user.password == passwordTF.text!{
                role = user.role
                username = user.username
                validation = 1
            }
        }
        if validation != 1{
            let alert = UIAlertController(title: "Invalid Input. Please Try Again.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            usernameTF.text = ""
            passwordTF.text = ""
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabbar = segue.destination as? tabbar{
            tabbar.role = role
            tabbar.username = username
        }
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        usernameTF.text = ""
        passwordTF.text = ""
    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
