//
//  URLRequest+Extensions.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//


import RxSwift
import RxCocoa
import UIKit



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
    
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        var request = URLRequest(url: resource.url)
        request.timeoutInterval = Double.infinity
        request.httpMethod = resource.httpMethod.rawValue
        request.addValue("L9lRuYyVxhjYKFaekuotNvOWnbcN3WDA", forHTTPHeaderField: "apikey")

        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                switch (response.statusCode){
                    case 200..<300:
                        return try JSONDecoder().decode(T.self, from: data)
                    case 429 :
                        throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                    default:
                        throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                        
                }
        }.asObservable()
        
    }
}
