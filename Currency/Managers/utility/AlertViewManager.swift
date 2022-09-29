//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import Foundation
import UIKit


struct AlertViewManager {
    
    static func presentAlertView(from viewController:UIViewController, message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style:.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
