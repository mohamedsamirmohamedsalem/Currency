//
//  AppConstants.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import UIKit
 
struct AppConstants {

    static let mainStoryBoard = "Main"
    
    static var bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    
    enum StoryBoardIds: String {
        case ConvertCurrency = "ConvertCurrencyVC"
        case CurrencyDetails = "CurrencyDetailsVC"
    }

    let day1 = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!.get(.day)
    let day2 = Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!.get(.day)
    let day3 = Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!.get(.day)
    
    
    
}

typealias VoidReturn = ( () -> Void )?


