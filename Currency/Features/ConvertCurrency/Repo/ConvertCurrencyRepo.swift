//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//


import UIKit
import Foundation
import CoreData
import RxSwift
import RxRelay

protocol ConvertCurrencyRepoProtocol: AnyObject {
    
    var networkManager: NetworkManagerProtocol?    { get }
    var databaseManager: DatabaseManagerProtocol?  { get }
    var networkError: PublishSubject<NetworkError> { get }
    var symbolsObservable: Observable<[String]>    { get }
    var loadingObservable : BehaviorRelay<Bool>      { get }
    var convertCurrencyResponse: PublishSubject<ConvertCurrencyResponse> { get }
    
    func fetchSymbols()
    func fetchConvertedAmount(to :String , from : String,amount :String)
    
}

class ConvertCurrencyRepo: ConvertCurrencyRepoProtocol{
    
    let disposeBag = DisposeBag()
    
    var networkError =  PublishSubject<NetworkError>()
    
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable: BehaviorRelay<Bool> {
        return loadingBehavior
    }
    
    private var currencySymbols = PublishSubject<[String]>()
    var symbolsObservable : Observable<[String]> {
        return currencySymbols
    }
    
    internal var convertCurrencyResponse = PublishSubject<ConvertCurrencyResponse>()
    var convertCurrencyObservable : Observable<ConvertCurrencyResponse>{
        return convertCurrencyResponse
    }
    
    var networkManager: NetworkManagerProtocol?
    var databaseManager: DatabaseManagerProtocol?
    
    init(networkManager: NetworkManagerProtocol?,databaseManager: DatabaseManagerProtocol?) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
        self.subscribeOnNetworkError()
    }
    
    private func subscribeOnNetworkError(){
        networkManager?.networkError
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.networkError.onNext(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchSymbols(){
        loadingBehavior.accept(true)
        networkManager?.load(resource: SymbolsModel.resource)
            .observe(on: MainScheduler.instance)
            .retry(2)
            .catchAndReturn(SymbolsModel.errorModel)
            .subscribe(onNext: { [weak self] model in
                
                let symbols = [String](model.symbols.keys)
                self?.currencySymbols.onNext(symbols)
                self?.loadingBehavior.accept(false)
                
            }).disposed(by: disposeBag)
    }
    
    func fetchConvertedAmount(to: String, from: String, amount: String) {
        loadingBehavior.accept(true)
        networkManager?.load(resource: ConvertCurrencyResponse.resource(to: to, from: from, amount: amount))
            .observe(on: MainScheduler.instance)
            .retry(2)
            .catchAndReturn(ConvertCurrencyResponse.errorModel)
            .subscribe(onNext: { [weak self] response in
                
                self?.convertCurrencyResponse.onNext(response)
                self?.loadingBehavior.accept(false)
                self?.saveConversionAmount(fromAmount: Double(amount) ?? 0.0, toAmount: response.result, fromCurrency: from, toCurrency: to)
                
            }).disposed(by: disposeBag)
        
    }
    
    func saveConversionAmount(fromAmount: Double, toAmount: Double, fromCurrency: String ,toCurrency:String) {
        
        let currencyHistoryEntity = CurHistoryEntity(context: databaseManager!.context)
        currencyHistoryEntity.date = Date.now
    
        currencyHistoryEntity.fromAmount = fromAmount
        currencyHistoryEntity.fromCurrency = fromCurrency
        currencyHistoryEntity.toAmount = toAmount
        currencyHistoryEntity.toCurrency = toCurrency
        
        databaseManager?.saveEntity(entity: currencyHistoryEntity)
    }
    
}





