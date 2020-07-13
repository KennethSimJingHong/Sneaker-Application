//
//  productViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class productViewController: UIViewController, productCollectionViewCellDelegate {
    var indexPath:IndexPath?
    let realm = try! Realm()
    var sneakers = [product]()
    var wishlists = [wishlist]()
    var role = ""
    var username = ""
    var value = ""
    var items = [wishlistitems]() // this one is for the use on love image
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        sneakers = Array(realm.objects(product.self))
        if role == "customer"{
            self.navigationItem.rightBarButtonItem = nil
            CollectionView.reloadData()
        }

    }

    func didButtonTapped(cell: productCollectionViewCell) {
        indexPath = self.CollectionView.indexPath(for: cell)
    }
    override func viewWillAppear(_ animated: Bool) {
        sneakers = Array(realm.objects(product.self))
        wishlists = Array(realm.objects(wishlist.self))
        CollectionView.reloadData()
    }
    
    
    @IBAction func mapTapped(_ sender: UIBarButtonItem) {
           let alert = UIAlertController(title: "Do you wish to move to map?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
           //define destination
           let latitude:CLLocationDegrees = 3.149059
           let longitude:CLLocationDegrees = 101.713515
           let regionDistance:CLLocationDistance = 1000
           let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
           let regionSpan = MKCoordinateRegion(center: coordinates,latitudinalMeters: regionDistance,longitudinalMeters: regionDistance)
           let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
           let placemark = MKPlacemark(coordinate: coordinates)
           let mapItem = MKMapItem(placemark: placemark)
           mapItem.name = "SNEAKERS."
           mapItem.openInMaps(launchOptions: options)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
           self.tabBarController?.selectedIndex = 0
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loveTapped(_ sender: UIButton) {
        wishlists = Array(realm.objects(wishlist.self))
        if let wishlist = wishlists.first(where: {$0.name == sneakers[(indexPath?.item)!].name}){
            sender.setBackgroundImage(UIImage(named:"love"), for: .normal)
            items = items.filter{$0.name != wishlist.name}
            if let i = wishlists.first(where: {$0.name == sneakers[(indexPath?.item)!].name && $0.username == username}){
                do{
                    try realm.write{
                        realm.delete(i)
                    }
                }catch{
                    print("Error: \(error)")
                }
            }
        }else{
            sender.setBackgroundImage(UIImage(named:"love-2"), for: .normal)
            items.append(wishlistitems(name: sneakers[indexPath!.item].name!, price: sneakers[indexPath!.item].price))
            do{
                let newwlitem = wishlist(name: sneakers[indexPath!.item].name!, price: sneakers[indexPath!.item].price, username: username)
                try realm.write{
                    realm.add(newwlitem)
                }
            }catch{
                print("Error: \(error)")
            }
        }
    }
}



extension productViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sneakers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! productCollectionViewCell
        cell.delegate = self
        cell.name.text = sneakers[indexPath.item].name
        cell.price.text = "MYR " + String(format: "%.2f", sneakers[indexPath.item].price)
        //get image locally
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(sneakers[indexPath.item].name!).png")
        if fileManager.fileExists(atPath: imagePath){
            cell.imageView.image = UIImage(contentsOfFile: imagePath)
        }
        if role == "admin"{
            cell.loveButton.isHidden = true
        }
        if let _ = wishlists.first(where: {$0.name == cell.name.text}){
            cell.loveButton.setBackgroundImage(UIImage(named: "love-2"), for: .normal)
        }else{
            cell.loveButton.setBackgroundImage(UIImage(named: "love"), for: .normal)
        }
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if role == "customer"{
            let infovc = (storyboard?.instantiateViewController(identifier: "infoViewController")) as! infoViewController
            infovc.pname = sneakers[indexPath.item].name!
            self.navigationController?.pushViewController(infovc, animated: true)
        }else{
            let editvc = (storyboard?.instantiateViewController(identifier: "editViewController")) as! editViewController
            editvc.pinfo.append(product(name: sneakers[indexPath.item].name!, price: sneakers[indexPath.item].price, desc: sneakers[indexPath.item].desc!, sizes: sneakers[indexPath.item].sizes!))
            self.navigationController?.pushViewController(editvc, animated: true)
        }
    }
    
}


extension productViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.CollectionView.frame.width
        let height = self.CollectionView.frame.height
        return CGSize(width: width/2 - 2, height: height/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}
