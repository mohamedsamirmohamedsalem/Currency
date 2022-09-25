//
//  ConvertCurrencyAssembler.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import UIKit

extension DependencyAssemblerManager: ConvertCurrencyFactory {
    
    func makeConvertCurrencyVM(coordinator: ConvertCurrencyCoordinator) -> ConvertCurrencyVM {
        let viewModel = ConvertCurrencyVM(repository: repoConvertCurrency)
        return viewModel
    }
    
    func makeConvertCurrencyVC(coordinator: ConvertCurrencyCoordinator) -> ConvertCurrencyVC? {
        
        guard  let viewController = UIStoryboard(name: AppConstants.mainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: AppConstants.StoryBoardIds.ConvertCurrency.rawValue) as? ConvertCurrencyVC else {
            print("Wrong identifier provided , id must be \(ConvertCurrencyVC.self)")
            return nil
        }
    
        viewController.navDelegate = coordinator
        viewController.currencyVM = self.makeConvertCurrencyVM(coordinator: coordinator)
        return viewController
}

func makeConvertCurrencyCoordinator(router: Router, factory: ConvertCurrencyFactory) ->  ConvertCurrencyCoordinator {
    let coordinator = ConvertCurrencyCoordinator(router: router, factory: factory)
    return coordinator
    }


}


