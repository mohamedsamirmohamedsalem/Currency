//
//  CurrencyConvertVC+TableViewDelgate.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation
import UIKit


extension CurrencyConvertViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.symbolsList.isEmpty ? 0 : self.symbolsList.count
    }
    
}
