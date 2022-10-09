


//
//  CurrencyDetailsVM.swift
//  Currency
//
//  Created by Mohamed Samir 30/09/2022.
//

import RxSwift
import RxRelay

struct CurrencyDetailsVM {
    
    let disposeBag = DisposeBag()
    
    private var networkError = PublishSubject<NetworkError>()
    var networkErrorObservable : PublishSubject<NetworkError> {
        return networkError
    }
    
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable: BehaviorRelay<Bool> {
        return loadingBehavior
    }
  
    private var popularCurrency = PublishSubject<[String:Double]>()
    var PopularCurrenciesObservable : Observable<[String:Double]> {
        return popularCurrency
    }
    
    internal var currencyHistory = PublishSubject<[[CurHistoryEntity]]>()
    var currencyHistoryObservable : Observable<[[CurHistoryEntity]]> {
        return currencyHistory
    }
    
    weak var repository: CurrencyDetailsRepoProtocol?
    var data: [Double:String]
    init(repository: CurrencyDetailsRepoProtocol?,data:[Double:String]) {
        self.repository = repository
        self.data = data
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
    
    func fetchPopularCurrencies(baseCurrency: String){

        repository?.PopularCurrenciesObservable.subscribe(onNext: { response in
            popularCurrency.onNext(response)
        }).disposed(by: disposeBag)
         
        repository?.fetchPopularCurrencies(baseCurrency: baseCurrency)
    }
    func fetchHistoricalData(){
        // view model observing for historical data from database
        repository?.currencyHistoryObservable.subscribe(onNext: { currencyHistoryList in
            currencyHistory.onNext(currencyHistoryList)
        }).disposed(by: disposeBag)
         
        repository?.fetchHistoricalData()
    }
    
    
    
}

