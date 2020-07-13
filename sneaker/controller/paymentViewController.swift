//
//  paymentViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 11/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import SVProgressHUD

class paymentViewController: UIViewController {

    @IBOutlet weak var banktype: UILabel!
    @IBOutlet weak var cardno: theTextField!
    @IBOutlet weak var expirydate: theTextField!
    @IBOutlet weak var cvv: theTextField!
    @IBOutlet weak var holdername: theTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func paymentTapped(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Progressing...")
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.dismiss(withDelay: 3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.banktype.text != "SELECTED BANK" && self.cardno.text != "" && self.expirydate.text != "" && self.cvv.text != "" && self.holdername.text != ""{
                let alert = UIAlertController(title: "Payment Successful", message: "Tracking number has sent to your email address. Thank You. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                 
                     _ = self.navigationController?.popViewController(animated: true)
                     let navvc = self.tabBarController?.viewControllers![2] as! UINavigationController
                     let cartvc = navvc.topViewController as! cartViewController
                     cartvc.products = []
                     cartvc.quantity = []
                    }))
                    self.present(alert, animated: true, completion: nil)
            }else{
                let alert1 = UIAlertController(title: "Please Try Again.", message: "", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert1, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func maybank(_ sender: UIButton) {
        banktype.text = "Maybank"
    }
    @IBAction func rhb(_ sender: UIButton) {
        banktype.text = "RHB Bank"
    }
    @IBAction func hongleong(_ sender: UIButton) {
        banktype.text = "Hong Leong Bank"
    }
    
}
