//
//  ConvertCurrencyCoordinator.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import UIKit

class ConvertCurrencyCoordinator: Coordinator {
  
    var children: [Coordinator] = []

    var router: Router
    
    private let factory: ConvertCurrencyFactory
    
    init(router: Router, factory: ConvertCurrencyFactory) {
        self.router = router
        self.factory = factory
    }
    func present(animated: Bool, onDismissed: VoidReturn) {
        if let convertCurrencyVC = factory.makeConvertCurrencyVC(coordinator: self){
            router.present(convertCurrencyVC, animated: true, onDismissed: nil)
        }
        
    }
}

extension ConvertCurrencyCoordinator: ConvertCurrencyVCDelegate {

    func navigateToNextScreen(_ viewController: ConvertCurrencyVC) {
        if let navController = viewController.navigationController {
            let router = NavigationRouter(navigationController: navController)
            let assembler = DependencyAssemblerManager.shared
            let coordinator = assembler.makeCurrencyDetailsCoordinator(router: router, factory: assembler)

            presentChild(coordinator, animated: true, onDismissed: nil)
        }
      
        }
    
    
}

