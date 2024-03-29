//
//  DependencyAssembler.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//


class DependencyAssemblerManager {
    
    static let shared = DependencyAssemblerManager()
    private init() {}
    
    var networkManager: NetworkManagerProtocol?
    var databaseManager: DatabaseManagerProtocol?
    
    lazy var repoConvertCurrency = ConvertCurrencyRepo(networkManager: networkManager,databaseManager: databaseManager)
    
    lazy var repoCurrencyDetails = CurrencyDetailsRepo(networkManager: networkManager,databaseManager: databaseManager)
  
    
}
