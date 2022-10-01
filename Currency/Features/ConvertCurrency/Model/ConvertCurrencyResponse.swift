//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import Foundation

struct ConvertCurrencyResponse : Codable {
    let success: Bool
    let result: Double
}

extension ConvertCurrencyResponse {
    
    static func resource(to: String , from: String , amount: String) -> Resource<ConvertCurrencyResponse>{
        guard let url = URL(string: Endpoints.currencyConvert(to: to, from: from, amount: amount)) else{
            fatalError("URL is incorrect!")
        }
        print("url \(url)")
        return Resource<ConvertCurrencyResponse>(url: url,httpMethod: HttpMethod.get)
    }
    static var errorModel: ConvertCurrencyResponse {
        return ConvertCurrencyResponse(success: false,result: 0)
    }
}
