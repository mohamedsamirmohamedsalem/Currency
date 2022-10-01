


//
//  CurrencyDetailsFactory.swift
//  Currency
//
//  Created by Mohamed Samir 30/09/2022.
//


protocol CurrencyDetailsFactory{
    func makeCurrencyDetailsVC(coordinator: CurrencyDetailsCoordinator) -> CurrencyDetailsVC?
    
    func makeCurrencyDetailsVM(coordinator: CurrencyDetailsCoordinator) -> CurrencyDetailsVM

    func makeCurrencyDetailsCoordinator(router: Router, factory: CurrencyDetailsFactory,data: [Double:String]) -> CurrencyDetailsCoordinator
}
