//
//  AppConstants.swift
//  Currency
//
//  Created by Mohamed Samir on 18/09/2022.
//

import Foundation


struct AppConstants {
    static let apiKey = "omrfD13sfU2P8GDipZO52ceX6OhTvqXZ"
    
    
    static let mainStoryBoard = "Main"
    
    enum StoryBoardIds: String {
        case ConvertCurrency = "ConvertCurrencyVC"
        case CurrencyDetails = "CurrencyDetailsVC"
    }

}

typealias VoidReturn = ( () -> Void )?


