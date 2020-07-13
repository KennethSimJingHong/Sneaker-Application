//
//  wishlistViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 10/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

struct wishlistitems{
    var name:String
    var price:Double
}
class wishlistViewController: UIViewController {
    var wishlists = [wishlist]()
    let realm = try! Realm()
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        wishlists = Array(realm.objects(wishlist.self))
        TableView.reloadData()
    }

    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        self.TableView.isEditing = !self.TableView.isEditing
         sender.title = (self.TableView.isEditing) ? "Done" : "Edit"
    }
}

extension wishlistViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! wishlistTableViewCell
        cell.proname.text = wishlists[indexPath.item].name
        cell.proprice.text =  "MYR " + String(format: "%.2f", wishlists[indexPath.item].price)
        //get image locally
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(wishlists[indexPath.item].name!).png")
        if fileManager.fileExists(atPath: imagePath){
            cell.ImageView.image = UIImage(contentsOfFile: imagePath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infovc = storyboard?.instantiateViewController(identifier: "infoViewController") as! infoViewController
        infovc.pname = wishlists[indexPath.item].name!
        self.navigationController?.pushViewController(infovc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
                do{
                    try realm.write{
                        realm.delete(wishlists[indexPath.item])
                    }
                }catch{
                    print("Error: \(error)")
                }
            wishlists.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
}
