//
//  AppConstants.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import Foundation


struct AppConstants {

    static let mainStoryBoard = "Main"
    
    enum StoryBoardIds: String {
        case ConvertCurrency = "ConvertCurrencyVC"
        case CurrencyDetails = "CurrencyDetailsVC"
    }

}

typealias VoidReturn = ( () -> Void )?


