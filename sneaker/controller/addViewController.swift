//
//  addViewController.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
import RealmSwift

class addViewController: UIViewController{
    let realm = try! Realm()
    var all_sizes: [Double] = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18] // all possible sneaker sizes
    var selectedsizes: [String] = []
    @IBOutlet weak var nameTF: theTextField!
    @IBOutlet weak var priceTF: theTextField!
    @IBOutlet weak var descTF: theTextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
    }
    
    @IBAction func importTapped(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        present(image, animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        let name = nameTF.text
        let price = Double(priceTF.text!)
        let desc = descTF.text
        let sizes = selectedsizes.joined(separator: ",")
        
        if nameTF.text != "" && priceTF.text != "" && descTF.text != "" && img.image != nil && sizes != ""{
            if isValidPrice(priceTF.text!){
                let newproduct = product(name: name!, price: price!, desc: desc!, sizes: sizes)
                do{
                    try realm.write{
                        realm.add(newproduct)
                    }
                    saveImage(imageName: "\(newproduct.name!).png")
                    let alert = UIAlertController(title: "Product Added.", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    nameTF.text?.removeAll()
                    priceTF.text?.removeAll()
                    descTF.text?.removeAll()
                    selectedsizes.removeAll()
                    img.image = nil
                    CollectionView.reloadData()
                }catch{
                    print("Error: \(error)")
                }
            }else{
                let alert = UIAlertController(title: "Invalid Input: Price", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Please fill in the blank.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveImage(imageName :String){
        //create an instance of file manager
        let fileManager = FileManager.default
        //get imagepath
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get image
        let image = img.image
        //get pngdata for this image
        let data = image!.pngData()
        //store it
        fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
        print(imagePath)
    }
    
    func isValidPrice(_ price: String) -> Bool {
        let priceRegEx = "[0-9]{1,}.[0-9]{1,}|[0-9]{1,}"
        let pricePred = NSPredicate(format:"SELF MATCHES %@", priceRegEx)
        return pricePred.evaluate(with: price)
    }
}

extension addViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            img.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension addViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return all_sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! addCollectionViewCell
        cell.sizeLabel.text = "UK \(all_sizes[indexPath.item])"
        cell.contentView.backgroundColor = UIColor.white
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! addCollectionViewCell
        if cell.contentView.backgroundColor == UIColor.lightGray{
            cell.contentView.backgroundColor = UIColor.white
            selectedsizes = selectedsizes.filter({$0 != String(all_sizes[indexPath.item])})
        }else{
            cell.contentView.backgroundColor = UIColor.lightGray
            selectedsizes.append(String(all_sizes[indexPath.item]))
        }
    }

}

extension addViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.CollectionView.frame.width
        let height = self.CollectionView.frame.height
        return CGSize(width: width/4 - 6 , height: height/4 - 7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
