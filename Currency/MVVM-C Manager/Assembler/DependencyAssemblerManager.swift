//
//  DependencyAssembler.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import UIKit
import RxSwift

protocol NetworkManagerProtocol{
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
}

protocol DatabaseManagerProtocol{}
class DatabaseManager: DatabaseManagerProtocol{}

class DependencyAssemblerManager {
    
    static let shared = DependencyAssemblerManager()
    private init() {}
    
    var networkManager: NetworkManagerProtocol?
    var databaseManager: DatabaseManagerProtocol?
    
    lazy var convertCurrencyRepository = ConvertCurrencyRepository(networkManager: networkManager,databaseManager: databaseManager)
}
