
class CurrencyDetailsCoordinator: Coordinator {
  
    var children: [Coordinator] = []

    var router: Router
    
    private let factory: CurrencyDetailsFactory
    
    init(router: Router, factory: CurrencyDetailsFactory) {
        self.router = router
        self.factory = factory
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

