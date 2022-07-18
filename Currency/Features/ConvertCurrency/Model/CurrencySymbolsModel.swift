//
//  CurrencyModel.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation

// MARK: - CurrencySymbolsModel

struct CurrencySymbolsModel: Codable{
    let success :Bool
    let symbols: [String:String]
}

extension CurrencySymbolsModel {
    
    static var all : Resource<CurrencySymbolsModel> = {
        guard let url = URL(string: Endpoints.symbols) else {
        fatalError("URL is incorrect!")
        }
        return Resource<CurrencySymbolsModel>(url: url,httpMethod: HttpMethod.get)
    }()
    
    static var empty: CurrencySymbolsModel {
        return CurrencySymbolsModel(success: false,symbols: ["" : ""])
    }
}
