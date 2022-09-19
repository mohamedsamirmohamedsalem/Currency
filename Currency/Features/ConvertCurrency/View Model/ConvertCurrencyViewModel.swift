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
    }
    
    func gettingSymbolsFromApi(){
        loadingBehavior.accept(true)
        repository?.getSymbols()
        loadingBehavior.accept(false)

        // view model observing for symbols
        repository?.currencySymbols.subscribe(onNext: {  symbols in
            self.currencySymbols.onNext(symbols)
        }).disposed(by: disposeBag)
    
    }
    
    func getConvertedAmount(to :String , from : String,amount :String){
        loadingBehavior.accept(true)
        repository?.getConvertedAmount(to: to, from: from, amount: amount)
        loadingBehavior.accept(false)

        // view model observing for converting data
        repository?.convertCurrencyResponse.subscribe(onNext: {  convertCurrencyModel in
            self.convertCurrencyModel.onNext(convertCurrencyModel)
        }).disposed(by: disposeBag)
    
    }
    
}
