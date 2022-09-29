//
//  URLRequest+Extensions.swift
//  Currency
//
//  Created by Mohamed Samir on 08/07/2022.
//

import RxSwift
import RxCocoa
import UIKit

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
    
    init(url: URL , httpMethod : HttpMethod) {
        self.url = url
        self.httpMethod = httpMethod
    }
}

protocol NetworkManagerProtocol{
    var networkError: PublishSubject<NetworkError> { get }
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
}

struct NetworkManager: NetworkManagerProtocol {
    
    var networkError =  PublishSubject<NetworkError>()
    
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        var request = URLRequest(url: resource.url)
        request.timeoutInterval = Double.infinity
        request.httpMethod = resource.httpMethod.rawValue
        request.addValue(AppConstants.apiKey, forHTTPHeaderField: "apikey")
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                
                switch (response.statusCode){
                    case 200..<300:
                        return try JSONDecoder().decode(T.self, from: data)
                    case 400, 401, 404, 429, 500..<999:
                        throw throwNetworkError(response.statusCode)
                    default:
                        networkError.onNext(NetworkError.httpRequestFailed)
                        throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                        
                }
            }.asObservable()
        
    }
    
    private func throwNetworkError(_ statusCode: Int) -> NetworkError {
        
        switch statusCode {
            case 400:
                networkError.onNext(NetworkError.unacceptableRequest)
                return NetworkError.unacceptableRequest
            case 401:
                networkError.onNext(NetworkError.unauthorized)
                return NetworkError.unauthorized
            case 404:
                networkError.onNext(NetworkError.requestedNotFound)
                return NetworkError.requestedNotFound
            case 429:
                networkError.onNext(NetworkError.tooManyRequests)
                return NetworkError.tooManyRequests
            case 500:
                networkError.onNext(NetworkError.serverError)
                return NetworkError.serverError
            default:
                networkError.onNext(NetworkError.httpRequestFailed)
                return NetworkError.httpRequestFailed
        }
    }
}

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
    case unacceptableRequest
    case unauthorized
    case requestedNotFound
    case tooManyRequests
    case serverError
    case httpRequestFailed
}


