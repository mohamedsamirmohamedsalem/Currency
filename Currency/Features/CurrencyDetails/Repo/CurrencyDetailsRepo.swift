
//
//  CurrencyDetailsRepo.swift
//  Currency
//
//  Created by Mohamed Samir 30/09/2022.
//

import RxSwift
import RxCocoa


protocol CurrencyDetailsRepoProtocol: AnyObject {
    
    var networkManager: NetworkManagerProtocol?    { get }
    var databaseManager: DatabaseManagerProtocol?  { get }
    var networkError: PublishSubject<NetworkError> { get }
    var loadingObservable : BehaviorRelay<Bool>      { get }
    
    var currencyHistoryObservable: Observable<[[CurHistoryEntity]]>  { get }
    var PopularCurrenciesObservable : Observable<[String:Double]> { get }
    
    func fetchPopularCurrencies(baseCurrency: String)
    func fetchHistoricalData()
}

class CurrencyDetailsRepo: CurrencyDetailsRepoProtocol{

    let disposeBag = DisposeBag()
    
    var networkError =  PublishSubject<NetworkError>()
    
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable: BehaviorRelay<Bool> {
        return loadingBehavior
    }
    
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
                self?.loadingBehavior.accept(false)
                
            }).disposed(by: disposeBag)
    }
    
    func fetchHistoricalData(){
        
        var currencyHistoryList: [CurHistoryEntity] = []
        var curArray: [CurHistoryEntity] = []
        currencyHistoryList = databaseManager?.fetchAllEntities(entity: CurHistoryEntity(context: databaseManager!.context)) as! [CurHistoryEntity]
        
        
        for item in currencyHistoryList {
            if  item.fromCurrency != nil && item.toCurrency != nil &&  item.date != nil {
                curArray.append(item)
            }
        }
        
        if curArray.isEmpty {
            currencyHistory.onNext([])
        }else{
            var firstDayList: [CurHistoryEntity] = []
            var secondDayList: [CurHistoryEntity] = []
            var thirdDayList: [CurHistoryEntity] = []
            
            for item in curArray {
                switch item.date?.get(.day) {
                    case AppConstants().day1:
                        firstDayList.append(item)
                    case AppConstants().day2:
                        secondDayList.append(item)
                    case AppConstants().day3:
                        thirdDayList.append(item)
                    default:
                        break
                }
            }
            currencyHistory.onNext([firstDayList, secondDayList, thirdDayList])
        }
    }
    
    
}


