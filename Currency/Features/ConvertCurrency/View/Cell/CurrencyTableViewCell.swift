//
//  CuurencyTableViewCell.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//
import UIKit

protocol ConvertCurrencyProtocol: AnyObject {
    func configureCell(text: String)
}


class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
}

extension CurrencyTableViewCell: ConvertCurrencyProtocol {
    
    func configureCell(text: String){
        self.currencyLabel.text = text        
    }
    
}
