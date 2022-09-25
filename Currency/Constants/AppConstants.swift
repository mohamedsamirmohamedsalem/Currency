//
//  AppConstants.swift
//  Currency
//
//  Created by Mohamed Samir on 18/09/2022.
//

import Foundation


struct AppConstants {
    static let apiKey = "csCrYjHNwxOce6imUZ8NWoCMBj5UjCmS"
    
    
    static let mainStoryBoard = "Main"
    
    enum StoryBoardIds: String {
        case ConvertCurrency = "ConvertCurrencyVC"
        case CurrencyDetails = "CurrencyDetailsVC"
    }

}

typealias VoidReturn = ( () -> Void )?


