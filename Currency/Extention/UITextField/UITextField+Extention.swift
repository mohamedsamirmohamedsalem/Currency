//
//  UITextField+Extention.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation
import UIKit

class BorderedUITextField: UITextField {

   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       self.layer.cornerRadius = 3.0
       self.layer.borderWidth = 1.0
       self.layer.borderColor = UIColor.systemTeal.cgColor
       self.layer.masksToBounds = true
   
     }
}
