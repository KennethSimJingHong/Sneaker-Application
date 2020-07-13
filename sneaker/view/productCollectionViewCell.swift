//
//  productCollectionViewCell.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
protocol productCollectionViewCellDelegate{
    func  didButtonTapped (cell: productCollectionViewCell)
}

class productCollectionViewCell: UICollectionViewCell {
    var delegate:productCollectionViewCellDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var loveButton: UIButton!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.delegate?.didButtonTapped(cell: self)
    }
}
