//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import UIKit

class AppDelegateRouter: Router {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: VoidReturn) {
        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func dismiss(animated: Bool) {}
    
    func setRootViewController(_ viewController: UIViewController) {}
    
    func setRootViewController(_ viewController: UIViewController, hideBar: Bool) {}
}
