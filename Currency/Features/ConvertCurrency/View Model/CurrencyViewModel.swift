//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Mohamed Samir on 18/07/2022.
//

import Foundation
import RxSwift
import RxRelay

struct CurrencyViewModel {
    
    let disposeBag = DisposeBag()
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable : BehaviorRelay<Bool> {
        return loadingBehavior
    }
    
    
    private var currencySymbols = PublishSubject<[String]>()
    var symbolsObservable : Observable<[String]> {
        return currencySymbols
    }
    
    private var convertCurrencyModel = PublishSubject<ConvertCurrencyModel>()
    var convertCurrencyObservable : Observable<ConvertCurrencyModel> {
        return convertCurrencyModel
    }
    
    
    
    func gettingSymbolsFromApi(){
        loadingBehavior.accept(true)
        WebService.load(resource: CurrencySymbolsModel.availableCurrencies)
            .observe(on: MainScheduler.instance)
            .catchAndReturn(CurrencySymbolsModel.errorModel)
            .subscribe(onNext: { currencySymbolsModel in
            
                var symbols : [String] = []
                _ = currencySymbolsModel.symbols.keys.map {symbols.append($0)}
                self.currencySymbols.onNext(symbols)
                self.loadingBehavior.accept(false)
            }).disposed(by: disposeBag)
    
    }
    
    func getConvertedAmount(to :String , from : String,amount :String){
        loadingBehavior.accept(true)
        WebService.load(resource: ConvertCurrencyModel.convertCurrency(to: to, from: from, amount: amount))
            .observe(on: MainScheduler.instance)
            .catchAndReturn(ConvertCurrencyModel.errorModel)
            .subscribe(onNext: { convertCurrencyModel in
                self.convertCurrencyModel.onNext(convertCurrencyModel)
                self.loadingBehavior.accept(false)
            }).disposed(by: disposeBag)
       
    }
    
}
