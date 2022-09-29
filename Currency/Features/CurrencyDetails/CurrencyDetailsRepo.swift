

import RxSwift
import UIKit

protocol CurrencyDetailsRepoProtocol: AnyObject {
    
    var networkManager: NetworkManagerProtocol?   { get }
    var databaseManager: DatabaseManagerProtocol? { get }
    var currencyHistoryObservable: Observable<[[CurHistoryEntity]]>  { get }
    var PopularCurrenciesObservable : Observable<[String:Double]> { get }
    
    func fetchPopularCurrencies(baseCurrency: String)
    func fetchHistoricalData()
}

class CurrencyDetailsRepo: CurrencyDetailsRepoProtocol{

    let disposeBag = DisposeBag()
    
    var networkError =  PublishSubject<NetworkError>()
    
    private var popularCurrency = PublishSubject<[String:Double]>()
    var PopularCurrenciesObservable : Observable<[String:Double]> {
        return popularCurrency
    }
    
    private var currencyHistory = PublishSubject<[[CurHistoryEntity]]>()
    var currencyHistoryObservable : Observable<[[CurHistoryEntity]]> {
        return currencyHistory
    }
    
    var networkManager: NetworkManagerProtocol?
    var databaseManager: DatabaseManagerProtocol?
    
    init(networkManager: NetworkManagerProtocol?,databaseManager: DatabaseManagerProtocol?) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }
    
    func fetchPopularCurrencies(baseCurrency: String){
        networkManager?.load(resource: PopularCurrenciesModel.resource(baseCurrency: baseCurrency))
            .observe(on: MainScheduler.instance)
            .retry(2)
            .catchAndReturn(PopularCurrenciesModel.errorModel)
            .subscribe(onNext: { [weak self] model in
                
                self?.popularCurrency.onNext(model.rates)
                
            }).disposed(by: disposeBag)
    }
    
    func fetchHistoricalData(){
        
        var currencyHistoryList: [CurHistoryEntity] = []
        var curArray: [CurHistoryEntity] = []
        currencyHistoryList = databaseManager?.fetchAllEntities(entity: CurHistoryEntity(context: databaseManager!.context)) as! [CurHistoryEntity]
        
        for item in currencyHistoryList {
            if item.fromAmount != nil && item.fromCurrency != nil && item.toAmount != nil &&   item.toCurrency != nil &&  item.date != nil {
                curArray.append(item)
            }
        }
        
        if curArray.isEmpty {
            currencyHistory.onNext([])
        }else{
            var firstDayList: [CurHistoryEntity] = []
            var secondDayList: [CurHistoryEntity] = []
            var thirdDayList: [CurHistoryEntity] = []
            
            let day1 = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!.get(.day)
            let day2 = Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!.get(.day)
            let day3 = Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!.get(.day)
            
            for item in curArray {
                switch item.date?.get(.day) {
                    case day1:
                        firstDayList.append(item)
                    case day2:
                        secondDayList.append(item)
                    case day3:
                        thirdDayList.append(item)
                    default:
                        break
                }
            }
            currencyHistory.onNext([firstDayList, secondDayList, thirdDayList])
        }
    }
    
    
}


