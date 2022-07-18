//
//  Endpoints.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation

struct Endpoints {
    
    static let baseURL = "https://api.apilayer.com/fixer"
    
    static let symbols = "\(baseURL)/symbols"
    static let soup = "\(baseURL)/soup"
    static let side = "\(baseURL)/side"
    
    static func detail(id: String) -> String {
        return "\(baseURL)/detail" + "/\(id)"
    }
}
