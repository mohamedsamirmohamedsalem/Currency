//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import RxSwift
import RxRelay

protocol ConvertCurrencyRepositoryProtocol: AnyObject {
    
    var networkManager: NetworkManagerProtocol?   { get }
    var databaseManager: DatabaseManagerProtocol? { get }
    var currencySymbols: PublishSubject<[String]> { get }
    var loadingBehavior : BehaviorRelay<Bool>     { get }
    var convertCurrencyResponse: PublishSubject<ConvertCurrencyResponse> { get }
    
    func fetchConvertedAmount(to :String , from : String,amount :String)
    func fetchSymbols()
}

class ConvertCurrencyRepository: ConvertCurrencyRepositoryProtocol{

    let disposeBag = DisposeBag()
    
    var loadingBehavior = BehaviorRelay<Bool>(value: true)
    
    internal var currencySymbols = PublishSubject<[String]>()
    var symbolsObservable : Observable<[String]> {
        return currencySymbols
    }
    
    internal var convertCurrencyResponse = PublishSubject<ConvertCurrencyResponse>()
    var convertCurrencyObservable : Observable<ConvertCurrencyResponse> {
        return convertCurrencyResponse
    }
    
    var networkManager: NetworkManagerProtocol?
    var databaseManager: DatabaseManagerProtocol?
    
    init(networkManager: NetworkManagerProtocol?,databaseManager: DatabaseManagerProtocol?) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }
    
    func fetchSymbols(){
        networkManager?.load(resource: SymbolsModel.resource)
            .observe(on: MainScheduler.instance)
            .catchAndReturn(SymbolsModel.errorModel)
            .subscribe(onNext: { currencySymbolsModel in
            
                let symbols : [String] = [String](currencySymbolsModel.symbols.keys)
                self.currencySymbols.onNext(symbols)
                self.loadingBehavior.accept(false)
                
            }).disposed(by: disposeBag)
    }
    
    func fetchConvertedAmount(to: String, from: String, amount: String) {
        networkManager?.load(resource: ConvertCurrencyResponse.resource(to: to, from: from, amount: amount))
            .observe(on: MainScheduler.instance)
            .catchAndReturn(ConvertCurrencyResponse.errorModel)
            .subscribe(onNext: { response in
                
                self.convertCurrencyResponse.onNext(response)
                self.loadingBehavior.accept(false)
                
            }).disposed(by: disposeBag)
       
    }
    
}

