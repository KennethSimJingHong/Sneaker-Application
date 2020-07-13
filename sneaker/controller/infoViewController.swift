//
//  infoViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 01/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

struct productlist{
    var name: String
    var price: Double
    var size: String
}

class infoViewController: UIViewController {
    let realm = try! Realm()
    var pname = ""
    var sizearray:[String]?
    var selectedsize: String = ""
    var products :[product] = []
    var moreresult = [String]()
    var priceindouble: Double?
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var CollectionView1: UICollectionView!
    @IBOutlet weak var CollectionView2: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desc: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        products = Array(realm.objects(product.self))
        CollectionView1.delegate = self
        CollectionView1.dataSource = self
        CollectionView2.delegate = self
        CollectionView2.dataSource = self
        for product in products{
            if product.name == pname{
                name.text = pname
                price.text = "MYR " + String(format: "%.2f", product.price)
                desc.text = product.desc
                priceindouble = product.price
                getImage(imageName: "\(product.name!).png")
                sizearray = product.sizes?.components(separatedBy: ",")

            }else{
                moreresult.append(product.name!)
            }
        }
        desc.isEditable = false
        sizearray!.sort {$0.localizedStandardCompare($1) == .orderedAscending}
    }
    
    func load(){
        for product in products{
            if product.name == pname{
                name.text = pname
                price.text = "MYR " + String(format: "%.2f", product.price)
                desc.text = product.desc
                priceindouble = product.price
                getImage(imageName: "\(product.name!).png")
                sizearray = product.sizes?.components(separatedBy: ",")
            }else{
                moreresult.append(product.name!)
            }
        }
        sizearray!.sort {$0.localizedStandardCompare($1) == .orderedAscending}
        CollectionView1.reloadData()
        CollectionView2.reloadData()
    }
    
    @IBOutlet weak var addToCart: UIButton!
    @IBAction func addcartTapped(_ sender: UIButton) {
        if addToCart.layer.backgroundColor == UIColor.black.cgColor{
            let navvc = tabBarController?.viewControllers![2] as! UINavigationController
            let cartvc = navvc.topViewController as! cartViewController
            cartvc.products.append(productlist(name: name.text!, price: priceindouble!, size: selectedsize))
            let alert = UIAlertController(title: "Item added.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                self.tabBarController?.selectedIndex = 2
                _ = self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    //get image
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
}

extension infoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CollectionView1{
            return sizearray!.count
        }else{
            return moreresult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CollectionView1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! sizeCollectionViewCell
            cell.size.text = "UK \(sizearray![indexPath.item])"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! resultCollectionViewCell
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(moreresult[indexPath.item]).png")
            if fileManager.fileExists(atPath: imagePath){
                cell.imageView.image = UIImage(contentsOfFile: imagePath)
            }else{
                cell.imageView.image = nil
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CollectionView1{
            let cell = collectionView.cellForItem(at: indexPath) as! sizeCollectionViewCell
            if cell.layer.borderWidth == 0{
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.lightGray.cgColor
                selectedsize = cell.size.text!
                addToCart.layer.backgroundColor = UIColor.black.cgColor
            }
        }else{
            pname = moreresult[indexPath.item]
            moreresult = []
            load()
            scrollview.setContentOffset(.zero, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == CollectionView1{
            let cell = collectionView.cellForItem(at: indexPath) as! sizeCollectionViewCell
            if cell.layer.borderWidth == 1{
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    
    //delegateflowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CollectionView1{
            let width = self.CollectionView1.frame.width
            let height = self.CollectionView1.frame.height
            return CGSize(width: width/3 - 4, height: height/5 - 2)
        }else{
            let width = view.frame.width
            let height = self.CollectionView2.frame.height
            return CGSize(width: width - 10, height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == CollectionView1{
            return 1
        }else{
            return 5
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == CollectionView1{
            return UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
        }else{
            return UIEdgeInsets(top: 1, left: 2.5, bottom: 1, right: 2.5)
        }
    }
}
