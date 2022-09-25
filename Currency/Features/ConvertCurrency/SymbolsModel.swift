//
//  CurrencyModel.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import Foundation

// MARK: - CurrencySymbolsModel

struct SymbolsModel: Codable{
    let success: Bool
    let symbols: [String:String]
}

extension SymbolsModel {
    
    static var resource : Resource<SymbolsModel> = {
        guard let url = URL(string: Endpoints.symbols) else {
            fatalError("URL is incorrect!")
        }
        return Resource<SymbolsModel>(url: url,httpMethod: HttpMethod.get)
    }()
    
    static var errorModel : SymbolsModel {
        return SymbolsModel(success: false,symbols: [ : ])
    }
}

