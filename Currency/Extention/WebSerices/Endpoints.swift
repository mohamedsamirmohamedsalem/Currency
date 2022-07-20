//
//  Endpoints.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation

struct Endpoints {
    
    static let baseURL = "https://api.apilayer.com"
    
    static let symbols = "\(baseURL)/fixer/symbols"
    
    static func currencyConvert(to: String , from: String , amount: String) -> String {
        return "\(baseURL)/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)"
    }
}
