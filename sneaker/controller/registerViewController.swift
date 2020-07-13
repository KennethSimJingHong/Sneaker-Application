//
//  registerViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

class registerViewController: UIViewController {
    let realm = try! Realm()
    var users = [user]()
    @IBOutlet weak var nameTF: theTextField!
    @IBOutlet weak var usernameTF: theTextField!
    @IBOutlet weak var passwordTF: theTextField!
    @IBOutlet weak var emailTF: theTextField!
    @IBOutlet weak var addressTF: theTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func registerTapped(_ sender: UIButton) {
        users = Array(realm.objects(user.self))
        // validating each textfield
        var failed: Bool = false
        let name = nameTF.text
        let username = usernameTF.text
        let password = passwordTF.text
        let email = emailTF.text
        let address = addressTF.text
        for user in users{
            if user.username == username{
                failed = true
            }
        }
        if name != "" && username != "" && password != "" && email != "" && address != ""{
            if failed == false{
                if isValidEmail(email!) && isValidUsername(username!) && isValidName(name!){
                    let newUser = user(name: name!, username: username!, password: password!, email: email!, address: address!, role: "customer") //create instance of class
                    do{
                        try realm.write{
                            realm.add(newUser)// add instance to database
                        }
                    }catch{
                        print("Error: \(error)")
                    }
                    let alert = UIAlertController(title: "Register Completed", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    nameTF.text = ""
                    usernameTF.text = ""
                    passwordTF.text = ""
                    emailTF.text = ""
                    addressTF.text = ""
                }else{
                    let alert = UIAlertController(title: "Please Follow The Format Given", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Username is taken.", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Please Fill In the Blank", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    func isValidUsername(_ username: String) -> Bool {
        let usernameRegEx = "\\w{7,18}"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: username)
    }

}
