//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import Foundation
import RxSwift
import RxRelay

struct ConvertCurrencyVM {
    
    let disposeBag = DisposeBag()
    
    private var networkError = PublishSubject<NetworkError>()
    var networkErrorObservable : PublishSubject<NetworkError> {
        return networkError
    }
    
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable: BehaviorRelay<Bool> {
        return loadingBehavior
    }
  

    private var currencySymbols = PublishSubject<[String]>()
    var symbolsObservable : Observable<[String]> {
        return currencySymbols
    }
    
    private var convertCurrencyModel = PublishSubject<ConvertCurrencyResponse>()
    var convertCurrencyObservable : Observable<ConvertCurrencyResponse> {
        return convertCurrencyModel
    }
    
    weak var repository: ConvertCurrencyRepoProtocol?
    init(repository:  ConvertCurrencyRepoProtocol?) {
        self.repository = repository
        self.subscribeOnLoading()
        self.subscribeNetworkError()
    }
    
    private func subscribeOnLoading(){
        // view model observing for loading
        repository?.loadingObservable.subscribe(onNext: { val in
            loadingBehavior.accept(val)
        }).disposed(by: disposeBag)
    }
    
    private func subscribeNetworkError(){
        // view model observing for loading
        repository?.networkError.subscribe(onNext: { error in
            self.networkError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    
    func gettingSymbolsFromApi(){
        

        repository?.fetchSymbols()
        // view model observing for symbols
        repository?.symbolsObservable.subscribe(onNext: {  symbols in
            self.currencySymbols.onNext(symbols)
        }).disposed(by: disposeBag)
    }
    
    func getConvertedAmount(to :String , from : String,amount :String){
        repository?.fetchConvertedAmount(to: to, from: from, amount: amount)
        
        // view model observing for converting data
        repository?.convertCurrencyResponse.subscribe(onNext: {  convertCurrencyModel in
            self.convertCurrencyModel.onNext(convertCurrencyModel)
        }).disposed(by: disposeBag)
    }
    
}
