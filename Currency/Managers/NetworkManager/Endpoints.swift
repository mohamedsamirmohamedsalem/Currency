//
//  Endpoints.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation
import UIKit



struct Endpoints {
    
    static let baseURL = "https://api.apilayer.com/fixer"
    
    static let symbols = "\(baseURL)/symbols"
   
    static func currencyConvert(to: String , from: String , amount: String) -> String {
        return "\(baseURL)/convert?to=\(to)&from=\(from)&amount=\(amount)"
    }
    
    private static let popularSymbols = "USD,EUR,JPY,GBP,AUD,CAD,CHF,CNH,HKD,NZD,EGP"
    static func  popularCurrenciesRates(baseCurrency: String) -> String{
        return "\(baseURL)/latest?symbols=\(popularSymbols)&base=\(baseCurrency)"
    }
    
}
