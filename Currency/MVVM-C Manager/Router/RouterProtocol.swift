//
//  RouterProtocol.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import UIKit

protocol Router {
    
    func present(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: VoidReturn)
    func dismiss(animated: Bool) // to dismiss entire Router
    func setRootViewController(_ viewController: UIViewController)
    func setRootViewController(_ viewController: UIViewController, hideBar: Bool)
}

extension Router {
    
    func present(_ viewController: UIViewController, animated: Bool){
        present(viewController, animated: true, onDismissed: nil)
    }

}
