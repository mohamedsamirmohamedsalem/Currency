
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
  
    var navDelegate: CurrencyDetailsVCDelegate?
    var viewModel: CurrencyDetailsVM?
  
    let disposeBag = DisposeBag()

    //MARK:  IBOutlets //////////////////////////////////////////////////////////////////////////////
    

    @IBOutlet weak var historyView: UIView!
    //MARK:  VC Life Cycle //////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let historyViewVC = UIHostingController(rootView: HistoryListView().environmentObject(historyModel))
        addChild(historyViewVC)
        historyViewVC.view.frame = historyView.frame
        view.addSubview(historyViewVC.view)
        historyViewVC.didMove(toParent: self)
        
        subscribeOnObservables()
        subscribeOnHistoricalData()
        
    }
    //MARK:  Methods //////////////////////////////////////////////////////////////////////////////
    private func  subscribeOnObservables(){
        // view model observing for historical data from database
        viewModel?.currencyHistoryObservable.subscribe(onNext: { [weak self] currencyHistoryList in
            self?.historyModel.history = currencyHistoryList
        }).disposed(by: disposeBag)
    }
    private func subscribeOnHistoricalData(){
        viewModel?.fetchHistoricalData()
    }
    
    
}


