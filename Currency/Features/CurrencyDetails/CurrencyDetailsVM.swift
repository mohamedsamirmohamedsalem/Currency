

import Foundation
import RxSwift
import RxRelay

struct CurrencyDetailsVM {
    
    let disposeBag = DisposeBag()
    
    private var popularCurrency = PublishSubject<[String:Double]>()
    var PopularCurrenciesObservable : Observable<[String:Double]> {
        return popularCurrency
    }
    
    internal var currencyHistory = PublishSubject<[[CurHistoryEntity]]>()
    var currencyHistoryObservable : Observable<[[CurHistoryEntity]]> {
        return currencyHistory
    }
    
    weak var repository: CurrencyDetailsRepoProtocol?
    init(repository: CurrencyDetailsRepoProtocol?) {
        self.repository = repository
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

