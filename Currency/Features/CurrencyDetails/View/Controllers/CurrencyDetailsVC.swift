
import UIKit
import RxSwift
import RxCocoa
import SwiftUI


protocol CurrencyDetailsVCDelegate: AnyObject {
    func backToPreviousScreen(_ viewController: CurrencyDetailsVC)
}


class CurrencyDetailsVC: UIViewController {

    //MARK:  Instances //////////////////////////////////////////////////////////////////////////////
    var historyModel: HistoryModel = HistoryModel(history: [[]])
    var activityView =  UIActivityIndicatorView ()
    var navDelegate: CurrencyDetailsVCDelegate?
    var viewModel: CurrencyDetailsVM?
    var convertFromAmount: Double?
    var convertFromCurrency: String?
    let disposeBag = DisposeBag()

    //MARK:  IBOutlets //////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var otherCurrencyTableView: UITableView!
    
    //MARK:  VC Life Cycle //////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let historyViewVC = UIHostingController(rootView:HistoryListView().environmentObject(historyModel))
        historyViewVC.view.frame = historyView.frame
        view.addSubview(historyViewVC.view)
        historyViewVC.didMove(toParent: self)
       
        registerNibFile()
        subscribeOnLoading()
        subscribeOnNetworkError()
        subscribeOnObservables()
        viewModel?.fetchPopularCurrencies(baseCurrency: convertFromCurrency ?? "USD")
        viewModel?.fetchHistoricalData()
    }
    //MARK:  Methods //////////////////////////////////////////////////////////////////////////////
    private func registerNibFile(){
        otherCurrencyTableView.RegisterNib(Cell: CurrencyTableViewCell.self)
    }
    
    private func  subscribeOnLoading(){
        viewModel?.loadingObservable.subscribe(onNext: { [weak self] isLoading in
            if(isLoading){
                self?.activityView.startAnimating()
            }else{
                self?.activityView.stopAnimating()
            }
        }).disposed(by: disposeBag)
    }
    
    private func  subscribeOnNetworkError(){
        viewModel?.networkErrorObservable.subscribe(onNext: { [weak self] error in
            AlertViewManager.presentAlertView(from: self!, message: "You finished your free trial requests")
        }).disposed(by: disposeBag)
    }
    
    
    private func  subscribeOnObservables(){
        // view model observing for historical data from database
        viewModel?.currencyHistoryObservable.subscribe(onNext:{ [weak self] currencyHistoryList in
            self?.historyModel.history = currencyHistoryList
        }).disposed(by: disposeBag)
        
        // view model observing for PopularCurrencies from API
        viewModel?.PopularCurrenciesObservable.bind(to: otherCurrencyTableView.rx.items(cellIdentifier: "\(CurrencyTableViewCell.self)", cellType: CurrencyTableViewCell.self)) { [weak self]
            ( row , popularCurrencies , cell ) in

            if let convertFromAmount = self?.convertFromAmount {
                let convertedAmount = String(format: "%.2f", popularCurrencies.value * (convertFromAmount))
                cell.configureCell(text: " \(convertedAmount)  \(popularCurrencies.key)")
            }
        }.disposed(by: disposeBag)
    }
    
 
}
