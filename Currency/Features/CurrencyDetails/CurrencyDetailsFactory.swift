
protocol CurrencyDetailsFactory{
    func makeCurrencyDetailsVC(coordinator: CurrencyDetailsCoordinator) -> CurrencyDetailsVC?
    
    func makeCurrencyDetailsVM(coordinator: CurrencyDetailsCoordinator) -> CurrencyDetailsVM

    func makeCurrencyDetailsCoordinator(router: Router, factory: CurrencyDetailsFactory) -> CurrencyDetailsCoordinator
}
