//
//  AppConstants.swift
//  Currency
//
//  Created by Mohamed Samir on 18/09/2022.
//

import Foundation


struct AppConstants {
    static let apiKey = "HWYbW8Ix1SOZzhjuz68Lvcmgnc3unzmG"
    
    static let mainStoryBoard = "Main"
    
    
    let day1 = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
    let day2 = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
    let day3 = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
    
    enum StoryBoardIds: String {
        case ConvertCurrency = "ConvertCurrencyVC"
        case CurrencyDetails = "CurrencyDetailsVC"
    }

}

typealias VoidReturn = ( () -> Void )?


