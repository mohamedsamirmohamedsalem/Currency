
import UIKit
import RxSwift
import RxCocoa


protocol CurrencyDetailsRepoProtocol: AnyObject {
    
    var networkManager: NetworkManagerProtocol?   { get }
    var databaseManager: DatabaseManagerProtocol? { get }
    var networkError: PublishSubject<NetworkError> { get }
    var loadingBehavior : BehaviorRelay<Bool>      { get }
    
    var currencyHistoryObservable: Observable<[[CurHistoryEntity]]>  { get }
    var PopularCurrenciesObservable : Observable<[String:Double]> { get }
    
    func fetchPopularCurrencies(baseCurrency: String)
    func fetchHistoricalData()
}

class CurrencyDetailsRepo: CurrencyDetailsRepoProtocol{

    let disposeBag = DisposeBag()
    
    var networkError =  PublishSubject<NetworkError>()
    
    var loadingBehavior = BehaviorRelay<Bool>(value: true)
    
    
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
        self.subscribeOnNetworkError()
        
    }
    
    private func subscribeOnNetworkError(){
        networkManager?.networkError
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.networkError.onNext(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchPopularCurrencies(baseCurrency: String){
        loadingBehavior.accept(true)
        
        networkManager?.load(resource: PopularCurrenciesModel.resource(baseCurrency: baseCurrency))
            .observe(on: MainScheduler.instance)
            .retry(2)
            .catchAndReturn(PopularCurrenciesModel.errorModel)
            .subscribe(onNext: { [weak self] model in
                
                self?.popularCurrency.onNext(model.rates)
               
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.loadingBehavior.accept(false)
                }
                
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


