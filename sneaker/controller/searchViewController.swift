//
//  searchViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 16/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

class searchViewController: UIViewController {
    var searchitem = [String]()
    let realm = try! Realm()
    var itemlist = [String]()
    var products = [product]()
    var searching = false
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        searchBar.delegate = self
        products = Array(realm.objects(product.self))
        for p in products{
            itemlist.append(p.name!)
        }
    }

}


extension searchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchitem.count
        }else{
            return itemlist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if searching{
            cell.textLabel?.text = searchitem[indexPath.item]
        }else{
            cell.textLabel?.text = itemlist[indexPath.item]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infovc = (storyboard?.instantiateViewController(identifier: "infoViewController")) as! infoViewController
        if searching{
            infovc.pname = searchitem[indexPath.item]
        }else{
            infovc.pname = itemlist[indexPath.item]
        }
        self.navigationController?.pushViewController(infovc, animated: true)
    }
}

extension searchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchitem = itemlist.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        TableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        TableView.reloadData()
    }
}
