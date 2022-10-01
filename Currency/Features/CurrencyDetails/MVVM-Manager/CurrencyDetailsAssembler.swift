

//
//  CurrencyDetailsAssembler.swift
//  Currency
//
//  Created by Mohamed Samir 30/09/2022.
//

import UIKit

extension DependencyAssemblerManager: CurrencyDetailsFactory {

    func makeCurrencyDetailsVM(coordinator: CurrencyDetailsCoordinator) -> CurrencyDetailsVM {
        let viewModel = CurrencyDetailsVM(repository: repoCurrencyDetails,data:coordinator.data)
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
    
    func makeCurrencyDetailsCoordinator(router: Router, factory: CurrencyDetailsFactory,data:[Double:String]) -> CurrencyDetailsCoordinator {
        let coordinator = CurrencyDetailsCoordinator(router: router, factory: factory,data: data)
        return coordinator
    }
    
    
}



