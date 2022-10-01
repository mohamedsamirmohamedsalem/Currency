//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 30/09/2022.
//

import Foundation

// MARK: - CurrencySymbolsModel

struct PopularCurrenciesModel: Codable{
    let rates: [String:Double]
}

extension PopularCurrenciesModel {
    
    static func resource(baseCurrency: String) -> Resource<PopularCurrenciesModel>{
        guard let url = URL(string: Endpoints.popularCurrenciesRates(baseCurrency: baseCurrency)) else {
            fatalError("URL is incorrect!")
        }
        return Resource<PopularCurrenciesModel>(url: url,httpMethod: HttpMethod.get)
    }
    
    static var errorModel : PopularCurrenciesModel {
        return PopularCurrenciesModel(rates: [ : ])
    }
}
