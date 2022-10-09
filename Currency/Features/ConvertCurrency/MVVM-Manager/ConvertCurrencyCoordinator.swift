//
//  ConvertCurrencyCoordinator.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//


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
    func navigateToNextScreen(_ viewController: ConvertCurrencyVC, data: [Double:String]) {
        if let navController = viewController.navigationController {
            let router = NavigationRouter(navigationController: navController)
            let assembler = DependencyAssemblerManager.shared
            let coordinator = assembler.makeCurrencyDetailsCoordinator(router: router, factory: assembler, data: data)

            presentChild(coordinator, animated: true, onDismissed: nil)
        }
    }
}

