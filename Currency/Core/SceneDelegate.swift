//
//  SceneDelegate.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: winScene)
        window?.frame = UIScreen.main.bounds
        
        let router = AppDelegateRouter(window: window!)
        
        let assembler = DependencyAssemblerManager.shared
        assembler.networkManager = NetworkManager()
        assembler.databaseManager = DatabaseManager()
        
        let coordinator = assembler.makeConvertCurrencyCoordinator(router: router, factory: assembler)
        coordinator.present(animated: true,onDismissed: nil)
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       AppDelegate().saveContext()
    }
}

