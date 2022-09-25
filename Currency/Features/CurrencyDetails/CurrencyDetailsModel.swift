
import Foundation

// MARK: - CurrencyDetailsModelModel

class CurrencyDetailsModel: Codable {
  
}

extension CurrencyDetailsModel {
    
    static var resource : Resource<CurrencyDetailsModel> = {
        guard let url = URL(string: Endpoints.symbols) else {
            fatalError("URL is incorrect!")
        }
        return Resource<CurrencyDetailsModel>(url: url,httpMethod: HttpMethod.get)
    }()
    
    static var errorModel : CurrencyDetailsModel{
        return CurrencyDetailsModel()
    }
}

