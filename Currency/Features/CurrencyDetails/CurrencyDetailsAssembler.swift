

import UIKit

extension DependencyAssemblerManager: CurrencyDetailsFactory {
   
    func makeCurrencyDetailsVM(coordinator: CurrencyDetailsCoordinator) -> CurrencyDetailsVM {
        let viewModel = CurrencyDetailsVM(repository: repoCurrencyDetails)
        return viewModel
    }
    
    func makeCurrencyDetailsVC(coordinator: CurrencyDetailsCoordinator) -> CurrencyDetailsVC? {

        guard let viewController = UIStoryboard(name: AppConstants.mainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: AppConstants.StoryBoardIds.CurrencyDetails.rawValue) as? CurrencyDetailsVC  else {
            print("Wrong identifier provided , id must be \(CurrencyDetailsVC.self)")
            return nil
        }
            
            viewController.navDelegate = coordinator
            viewController.viewModel = self.makeCurrencyDetailsVM(coordinator: coordinator)
            return viewController
    }
    
    func makeCurrencyDetailsCoordinator(router: Router, factory: CurrencyDetailsFactory) -> CurrencyDetailsCoordinator {
        let coordinator = CurrencyDetailsCoordinator(router: router, factory: factory)
        return coordinator
    }
    
    
}



