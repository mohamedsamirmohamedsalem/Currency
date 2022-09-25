

import Foundation
import RxSwift
import RxRelay

struct CurrencyDetailsVM {
    
    weak var repository: CurrencyDetailsRepoProtocol?
    init(repository: CurrencyDetailsRepoProtocol?) {
        self.repository = repository
    }
    
    
}

