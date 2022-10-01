//
//  UIButton+Extension.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import Foundation
import UIKit

class BorderedButton: UIButton {

   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       layer.borderWidth = 1.0
       layer.borderColor = tintColor.cgColor
       layer.cornerRadius = 8.0
       clipsToBounds = true
       setTitleColor(tintColor, for: .normal)
       setTitleColor(UIColor.white, for: .highlighted)
       setBackgroundImage(UIImage(), for: .highlighted)
   
     }
}

