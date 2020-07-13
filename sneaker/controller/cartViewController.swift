//
//  cartViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 02/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit



class cartViewController: UIViewController, ViewControllerDelegate{
    
    var indexpath:IndexPath?
    var products: [productlist] = []
    var quantity:[Double] = []
    @IBOutlet weak var quantityLabel: UILabel!
    var value: Double = 0.0
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var placeorderButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadfunc()
        TableView.delegate = self
        TableView.dataSource = self

    }
    
    func didTappedButton(cell: cartTableViewCell) {
        indexpath = self.TableView.indexPath(for: cell)
        quantity[indexpath!.item] = value
        loadfunc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadfunc()
    }
    
    func loadfunc(){
        TableView.reloadData()
        var total = 0.0
        var i = 0
        while products.count > quantity.count{
            quantity.append(1.0)
        }
        for product in products{
            total += (product.price * quantity[i])
            i += 1
        }
        if total != 0.0{
            price.text = "MYR " + String(format: "%.2f", total)
            placeorderButton.layer.backgroundColor = UIColor.black.cgColor
        }else{
            price.text = ""
            placeorderButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBAction func placeorderTapped(_ sender: UIButton) {
        if placeorderButton.layer.backgroundColor == UIColor.black.cgColor{
            let payvc = (storyboard?.instantiateViewController(identifier: "paymentViewController")) as! paymentViewController
            self.navigationController?.pushViewController(payvc, animated: true)
        }
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        self.TableView.isEditing = !self.TableView.isEditing
        sender.title = (self.TableView.isEditing) ? "Done" : "Edit"
    }
    
    @IBAction func quantityTapped(_ sender: UIStepper) {
        value = sender.value
    }
    
}

extension cartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cartTableViewCell
        cell.delegate = self
        cell.name.text = products[indexPath.item].name
        cell.price.text = "MYR " + String(format: "%.2f",products[indexPath.item].price)
        cell.size.text = products[indexPath.item].size
        cell.quantity.text = "Quantity: " + String(format: "%.0f",quantity[indexPath.item])
        if quantity[indexPath.item] != cell.stepper.value{
            cell.stepper.value = 1.0
        }
        //get image locally
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(products[indexPath.item].name).png")
        if fileManager.fileExists(atPath: imagePath){
            cell.pimage.image = UIImage(contentsOfFile: imagePath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            products.remove(at: indexPath.item)
            quantity.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            loadfunc()
        }
    }
}
