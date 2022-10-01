


//
//  CurrencyDetailsCoordinator.swift
//  Currency
//
//  Created by Mohamed Samir 30/09/2022.
//

class CurrencyDetailsCoordinator: Coordinator {
  
    var children: [Coordinator] = []

    var router: Router
    
    var data: [Double:String]
    
    
    private let factory: CurrencyDetailsFactory
    
    init(router: Router, factory: CurrencyDetailsFactory,data: [Double:String]) {
        self.router = router
        self.factory = factory
        self.data = data
    }
    func present(animated: Bool, onDismissed: VoidReturn) {
        if let viewController = factory.makeCurrencyDetailsVC(coordinator: self){
            router.present(viewController, animated: true, onDismissed: nil)
        }
    }
}

extension CurrencyDetailsCoordinator: CurrencyDetailsVCDelegate {
    
    func backToPreviousScreen(_ viewController: CurrencyDetailsVC) {
        self.router.dismiss(animated: true)
    }
    
}

