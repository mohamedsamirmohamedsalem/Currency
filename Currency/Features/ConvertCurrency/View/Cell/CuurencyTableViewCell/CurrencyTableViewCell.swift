//
//  CuurencyTableViewCell.swift
//  Currency
//
//  Created by Mohamed Samir on 06/07/2022.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
    
    func configureCell(text: String){
        self.currencyLabel.text = text
        
    }
}
