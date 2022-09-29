

import Foundation
import RxSwift
import RxRelay

struct CurrencyDetailsVM {
    
    let disposeBag = DisposeBag()
    
    internal var currencyHistory = PublishSubject<[[CurHistoryEntity]]>()
    var currencyHistoryObservable : Observable<[[CurHistoryEntity]]> {
        return currencyHistory
    }
    
    weak var repository: CurrencyDetailsRepoProtocol?
    init(repository: CurrencyDetailsRepoProtocol?) {
        self.repository = repository
    }
    
    
    func fetchHistoricalData(){
        // view model observing for historical data from database
        repository?.currencyHistoryObservable.subscribe(onNext: { currencyHistoryList in
            currencyHistory.onNext(currencyHistoryList)
        }).disposed(by: disposeBag)
         
        repository?.fetchHistoricalData()
      
    }
    
    
    
}

