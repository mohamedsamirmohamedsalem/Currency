
import UIKit
import RxSwift
import RxCocoa


protocol CurrencyDetailsVCDelegate: AnyObject {
    func backToPreviousScreen(_ viewController: CurrencyDetailsVC)
}


class CurrencyDetailsVC: UIViewController {
   
    //MARK:  Instances //////////////////////////////////////////////////////////////////////////////
    var navDelegate: CurrencyDetailsVCDelegate?
    var viewModel: CurrencyDetailsVM?
    let disposeBag = DisposeBag()
    let numberOfDays = 3

    
    //MARK:  IBOutlets //////////////////////////////////////////////////////////////////////////////
    

    //MARK:  VC Life Cycle //////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple
        subscribeOnHistoricalData(numberOfDays: numberOfDays)
        
    }
    //MARK:  Methods //////////////////////////////////////////////////////////////////////////////
 
    private func subscribeOnHistoricalData(numberOfDays: Int){
        
        viewModel?.fetchHistoricalData(numberOfDays: numberOfDays)
      
    }
    
    
}


