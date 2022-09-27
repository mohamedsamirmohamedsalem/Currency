

import RxSwift
import UIKit

protocol CurrencyDetailsRepoProtocol: AnyObject {
    
    var networkManager: NetworkManagerProtocol?   { get }
    var databaseManager: DatabaseManagerProtocol? { get }
    func fetchHistoricalData(numberOfDays: Int)
}

class CurrencyDetailsRepo{
    
    let disposeBag = DisposeBag()
    
    var networkError =  PublishSubject<NetworkError>()

    
    var networkManager: NetworkManagerProtocol?
    var databaseManager: DatabaseManagerProtocol?
    
    init(networkManager: NetworkManagerProtocol?,databaseManager: DatabaseManagerProtocol?) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }
    
}

extension CurrencyDetailsRepo: CurrencyDetailsRepoProtocol{
    
    func fetchHistoricalData(numberOfDays: Int){
        
        var fetchedData: [HistoricalEntity] = []
        fetchedData = databaseManager?.fetchAllEntities(entity: HistoricalEntity(context: databaseManager!.context)) as! [HistoricalEntity]
        
        //fetchedData.sort { $0.date.compare($1.date) == .orderedDescending }
        
        let result = fetchedData.prefix(numberOfDays)
        for res in result {
            print(res)
        }
    }
    
}


