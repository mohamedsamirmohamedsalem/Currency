//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Mohamed Samir on 18/07/2022.
//

import Foundation
import RxSwift
import RxRelay

struct ConvertCurrencyVM {
    
    let disposeBag = DisposeBag()
    
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable : BehaviorRelay<Bool> {
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
    
    weak var repository: ConvertCurrencyRepositoryProtocol?
    init(repository:  ConvertCurrencyRepositoryProtocol?) {
        self.repository = repository
        self.subscribeOnLoading()
    }
    
    private func subscribeOnLoading(){
        // view model observing for loading
        repository?.loadingBehavior.subscribe(onNext: { val in
            loadingBehavior.accept(val)
        }).disposed(by: disposeBag)
    }
    
    func gettingSymbolsFromApi(){
        
        repository?.loadingBehavior.accept(true)
        repository?.fetchSymbols()
        // view model observing for symbols
        repository?.currencySymbols.subscribe(onNext: {  symbols in
            self.currencySymbols.onNext(symbols)
        }).disposed(by: disposeBag)
        
    }
    
    func getConvertedAmount(to :String , from : String,amount :String){
        repository?.loadingBehavior.accept(true)
        repository?.fetchConvertedAmount(to: to, from: from, amount: amount)
        // view model observing for converting data
        repository?.convertCurrencyResponse.subscribe(onNext: {  convertCurrencyModel in
            self.convertCurrencyModel.onNext(convertCurrencyModel)
        }).disposed(by: disposeBag)
        
    }
    
}
