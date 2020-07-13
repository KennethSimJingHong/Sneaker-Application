//
//  cartTableViewCell.swift
//  sneaker
//
//  Created by Kenneth Sim on 02/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate{
    func didTappedButton(cell: cartTableViewCell)
}

class cartTableViewCell: UITableViewCell {
    var delegate:ViewControllerDelegate?
    @IBOutlet weak var pimage: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var size: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        self.delegate?.didTappedButton(cell: self)
    }
}
