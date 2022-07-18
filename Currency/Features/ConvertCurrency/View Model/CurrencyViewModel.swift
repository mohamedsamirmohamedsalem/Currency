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
    var loadingBehavior = BehaviorRelay<Bool>(value: true)
    private var symbolsList = PublishSubject<[String]>()
    var symbolsObservable : Observable<[String]> {
        return symbolsList
    }
    
    func gettingSymbolsFromApi(){
        loadingBehavior.accept(true)
        WebService.load(resource: CurrencySymbolsModel.all)
            .observe(on: MainScheduler.instance)
            .catchAndReturn(CurrencySymbolsModel.empty)
            .subscribe(onNext: { currencySymbolsModel in
            
                var symbols : [String] = []
                _ = currencySymbolsModel.symbols.keys.map {  key in
                    symbols.append(key)
                    
                }
                self.symbolsList.onNext(symbols)
  
            }).disposed(by: disposeBag)
        
        self.loadingBehavior.accept(false)
    }
    
}
