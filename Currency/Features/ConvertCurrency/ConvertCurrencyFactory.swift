//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//



protocol ConvertCurrencyFactory {
    
    func makeConvertCurrencyVC(coordinator: ConvertCurrencyCoordinator) -> ConvertCurrencyVC?
    
    func makeConvertCurrencyVM(coordinator: ConvertCurrencyCoordinator) ->  ConvertCurrencyVM
    
    func makeConvertCurrencyCoordinator(router: Router, factory: ConvertCurrencyFactory) -> ConvertCurrencyCoordinator
}
