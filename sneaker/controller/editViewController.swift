//
//  editViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 03/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

class editViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let realm = try! Realm()
    var pinfo = [product]()
    var sizearray: [String] = []
    var products = [product]()
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: theTextField!
    @IBOutlet weak var price: theTextField!
    @IBOutlet weak var desc: UITextView!
    var all_sizes: [Double] = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        products = Array(realm.objects(product.self))
        CollectionView.delegate = self
        CollectionView.dataSource = self
        name.text = pinfo[0].name
        price.text = String(pinfo[0].price)
        desc.text = pinfo[0].desc
        sizearray = pinfo[0].sizes!.components(separatedBy: ",")
        getImage(imageName: "\(pinfo[0].name!).png")
        
    }
    
    @IBAction func deleteTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure to delete selected item?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if let i = self.products.first(where: {$0.name == self.pinfo[0].name}){
                do{
                    try self.realm.write{
                        self.realm.delete(i)
                    }
                }catch{
                    print("Error: \(error)")
                }
            }
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeTapped(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        present(image, animated: true, completion: nil)

    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let string = sizearray.joined(separator: ",")
        let p = Double(price.text!)
        if let i = products.first(where: {$0.name == pinfo[0].name}){
            if isValidPrice(price.text!){
                do{
                    try realm.write{
                        i.name = name.text
                        i.desc = desc.text
                        i.price = p!
                        i.sizes = string
                    }
                }catch{
                    print("Error: \(error)")
                }
                modifyImage(imageName: "\(name.text!).png")
                if pinfo[0].name != name.text{
                    let name = pinfo[0].name!
                    print(name)
                    deleteImage(imageName: "\(name).png")
                }
                let alert = UIAlertController(title: "Successfully changed.", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Price should be number.", message: "", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler:nil))
                 self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            ImageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
    
    func deleteImage(imageName:String){
        let fileManager = FileManager.default
        //get imagepath
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //remove original image
        print(imagePath)
        try! fileManager.removeItem(atPath: imagePath)
    }
    
    func modifyImage(imageName :String){
        //create an instance of file manager
        let fileManager = FileManager.default
        //get imagepath
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        print(imagePath)
        //remove original image
        try? fileManager.removeItem(atPath: "\(imagePath).png")
        //get image
        let image = ImageView.image
        //get pngdata for this image
        let data = image!.pngData()
        //store it
        fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            ImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func isValidPrice(_ price: String) -> Bool {
        let priceRegEx = "^(-?)(0|([1-9][0-9]*))(\\.[0-9]+)?$"
        let pricePred = NSPredicate(format:"SELF MATCHES %@", priceRegEx)
        return pricePred.evaluate(with: price)
    }
    
}

extension editViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return all_sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! editCollectionViewCell
        cell.size.text = "UK \(all_sizes[indexPath.item])"
        for i in sizearray{
            if Double(i) == all_sizes[indexPath.item]{
                cell.layer.backgroundColor = UIColor.lightGray.cgColor
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! editCollectionViewCell
        if cell.layer.backgroundColor == UIColor.lightGray.cgColor{
            cell.layer.backgroundColor = UIColor.white.cgColor
            sizearray = sizearray.filter(){$0 != String(all_sizes[indexPath.item])}
        }else{
            cell.layer.backgroundColor = UIColor.lightGray.cgColor
            sizearray.append(String(all_sizes[indexPath.item]))
        }
    }
    
}

extension editViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.CollectionView.frame.width
        let height = self.CollectionView.frame.height
        return CGSize(width: width/4 - 10.5, height: height/4 - 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

