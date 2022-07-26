//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 20/07/2022.
//

import Foundation

struct ConvertCurrencyModel : Codable {
    let success: Bool
    let result: Double
}


extension ConvertCurrencyModel {
    
    static func convertCurrency(to: String , from: String , amount: String) -> Resource<ConvertCurrencyModel>{
        guard let url = URL(string: Endpoints.currencyConvert(to: to, from: from, amount: amount)) else {
        fatalError("URL is incorrect!")
        }
        print("url \(url)")
        return Resource<ConvertCurrencyModel>(url: url,httpMethod: HttpMethod.get)
}
   
    static var errorModel: ConvertCurrencyModel {
        return ConvertCurrencyModel(success: false,result: 0)
    }
}
