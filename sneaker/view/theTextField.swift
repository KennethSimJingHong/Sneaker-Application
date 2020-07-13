//
//  theTextField.swift
//  sneaker
//
//  Created by Kenneth Sim on 30/04/2020.
//  Copyright © 2020 Kenneth Sim. All rights reserved.
//

import UIKit

@IBDesignable
class theTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor(white: 231/255, alpha:1).cgColor
        self.layer.borderWidth = 1
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

}
