//
//  CurrencyConvertVC+TableViewDataSource.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation
import UIKit


extension CurrencyConvertViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeue(IndexPath: indexPath) as CuurencyTableViewCell
        cell.currencyLabel.text = self.dataSource[indexPath.row]
        return cell
    }
    
    
}

