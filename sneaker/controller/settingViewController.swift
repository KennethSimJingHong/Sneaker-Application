//
//  settingViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 01/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

protocol settingViewControllerDelegate{
    func didChange(_ user: user)
}

class settingViewController: UIViewController {
    let realm = try! Realm()
    var delegate:settingViewControllerDelegate?
    var uusername:String?
    @IBOutlet weak var name: theTextField!
    @IBOutlet weak var password: theTextField!
    @IBOutlet weak var email: theTextField!
    @IBOutlet weak var address: theTextField!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var role: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        let u = user(name: name.text!, username: username.text!, password: password.text!, email: email.text!, address: address.text!, role: role.text!)
        delegate?.didChange(u)
        let users = Array(realm.objects(user.self))
        for user in users{
            if user.username == username.text!{
                if name.text != "" && password.text != "" && email.text != "" && address.text != ""{
                    if isValidEmail(email.text!) && isValidName(name.text!){
                        do{
                            try realm.write{
                                user.name = name.text!
                                user.password = password.text!
                                user.email = email.text!
                                user.address = address.text!
                            }
                        }catch{
                            print("Error: \(error)")
                        }
                        navigationController?.popViewController(animated: true)
                    }else{
                        let alert = UIAlertController(title: "Please Follow The Format Given", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: "Please Fill In the Blank", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidName(_ name: String) -> Bool {
        let nameRegEx = "[a-z A-Z ]+"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
}
