//
//  URLRequest+Extensions.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa


enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL , httpMethod : HttpMethod) {
        self.url = url
        self.httpMethod = httpMethod
    }
}



struct WebService {
    
    static func load<T: Decodable>(resource: Resource<CurrencySymbolsModel>) -> Observable<T> {
        print(resource.httpMethod.rawValue)
        var request = URLRequest(url: resource.url,timeoutInterval: Double.infinity)
        request.httpMethod = resource.httpMethod.rawValue
        request.addValue("9H4EHPduV1xBPbbdvW8ZgAZ24JOd4F8S", forHTTPHeaderField: "apikey")
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
        }.asObservable()
        
    }
}
