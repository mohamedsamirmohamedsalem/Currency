//
//  NavigationRouter.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import UIKit

class NavigationRouter: NSObject {
    
    let navigationController: UINavigationController?
    var routerRouteController: UIViewController?
    var onDismissedViewController: [UIViewController: VoidReturn] = [:]
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
        self.routerRouteController = navigationController.viewControllers.first!
        super.init()
        navigationController.delegate = self
    }
}

// to call the onDismiss action if the user press back button
extension NavigationRouter: UINavigationControllerDelegate {
    
    func navController(_ navController: UINavigationController, didShowVC:UIViewController,animated: Bool){
        guard let dismissedVC = navController.transitionCoordinator?.viewController(forKey: .from) ,
              !navController.viewControllers.contains(dismissedVC) else { return }
        performOnDismissed(for: dismissedVC)
        
    }
}

extension NavigationRouter: Router {
    
    private func performOnDismissed(for viewController: UIViewController){
        guard let onDismiss = onDismissedViewController[viewController] else { return }
        onDismiss?()
        onDismissedViewController[viewController] = nil
        
    }
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: VoidReturn) {
        onDismissedViewController[viewController] = onDismissed
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        guard let routerRouteController = routerRouteController else {
            navigationController?.popToRootViewController(animated: animated)
            return
        }
        performOnDismissed(for: routerRouteController)
        navigationController?.popToViewController(routerRouteController,animated: animated)
        
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        setRootViewController(viewController,hideBar: false)
    }
    
    func setRootViewController(_ viewController: UIViewController, hideBar: Bool) {
        routerRouteController = viewController
        navigationController?.setViewControllers([viewController], animated: false)
        navigationController?.isNavigationBarHidden = hideBar
    }
    
    
}
