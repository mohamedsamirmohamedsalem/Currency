

import Foundation
import RxSwift
import RxRelay

struct CurrencyDetailsVM {
    
    let disposeBag = DisposeBag()
    weak var repository: CurrencyDetailsRepoProtocol?
    init(repository: CurrencyDetailsRepoProtocol?) {
        self.repository = repository
    }
    
    
    func fetchHistoricalData(numberOfDays: Int){
        
        repository?.fetchHistoricalData(numberOfDays: numberOfDays)
        // view model observing for symbols
 
        
    }
    
    
}

