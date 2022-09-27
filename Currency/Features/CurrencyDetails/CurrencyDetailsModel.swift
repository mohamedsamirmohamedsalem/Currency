
import Foundation

// MARK: - CurrencyDetailsModelModel

struct CurrencyDetailsModel: Codable {
    let success: Bool
    let base: String
    let rates: [String: [String:Double] ]
    let startDate, endDate: String


    enum CodingKeys: String, CodingKey {
        case success
        case base
        case startDate = "start_date"
        case endDate = "end_date"
        case rates


    }
    
    
}

extension CurrencyDetailsModel {
    
    static var resource : Resource<CurrencyDetailsModel> = {
        guard let url = URL(string: Endpoints.historicalDayCurrencies) else {
            fatalError("URL is incorrect!")
        }
        return Resource<CurrencyDetailsModel>(url: url,httpMethod: HttpMethod.get)
    }()
    
    static var errorModel : CurrencyDetailsModel{
        return CurrencyDetailsModel(success: false, base: "", rates: ["":["":0]], startDate: "", endDate: "")
    }
}

