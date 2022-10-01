//
//  Endpoints.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import Foundation

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
    
    static let apiKey = "4fCgjQ731lYW93PWps4Kiqiayy0PJYol"
    
}
