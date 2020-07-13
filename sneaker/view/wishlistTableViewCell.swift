//
//  wishlistTableViewCell.swift
//  sneaker
//
//  Created by Kenneth Sim on 10/05/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit
class wishlistTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var proname: UILabel!
    @IBOutlet weak var proprice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
