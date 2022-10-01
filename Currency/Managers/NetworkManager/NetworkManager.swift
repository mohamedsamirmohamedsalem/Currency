//
//  URLRequest+Extensions.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
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
        request.addValue(Endpoints.apiKey, forHTTPHeaderField: "apikey")
        
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



//for secure API
extension URLSession: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.cancelAuthenticationChallenge, nil);
                return
            }

            let certificate = SecTrustCopyCertificateChain(serverTrust)

            // SSL Policies for domain name check
            let policy = NSMutableArray()
            policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))

            //evaluate server certifiacte
            let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)

            //Local and Remote certificate Data
           let remoteCertificateData:NSData =  SecCertificateCopyData(certificate! as! SecCertificate)

            let pathToCertificate = Bundle.main.path(forResource: "mocky", ofType: "cer")
            let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
            //Compare certificates
            if(isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
                let _ : URLCredential =  URLCredential(trust: serverTrust)
                print("Certificate pinning is successfully completed")
                completionHandler(.useCredential,nil)
            }
            else {
                print("Certificate pinning is failed")
                completionHandler(.cancelAuthenticationChallenge,nil)
            }
        }
}
