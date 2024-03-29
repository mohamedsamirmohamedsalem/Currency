//
//  AppDelegate.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
  
    
    var context: NSManagedObjectContext {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         return context
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: AppConstants.bundleName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.red
        UINavigationBar().standardAppearance = navBarAppearance
        UINavigationBar().scrollEdgeAppearance = navBarAppearance
        
        
        // Add dummy test data only once for seeing it in history View
        let firstRun = UserDefaults.standard.bool(forKey: "firstRun")
        if !firstRun {
            for _ in 0..<3 {
                addTestData(day: 1)
                addTestData(day: 2)
                addTestData(day: 3)
            }
            UserDefaults.standard.set(true, forKey: "firstRun")
        }
     
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - Core Data stack
extension AppDelegate {
   
    // MARK: - Core Data Saving support

    func addTestData(day: Int) {
        
        guard let historyEntity = NSEntityDescription.entity(forEntityName: "\(CurHistoryEntity.self)", in: context)
        else { fatalError("could not find entity description")}
        
        let currencyHistoryEntity = CurHistoryEntity(entity: historyEntity, insertInto: context)
        currencyHistoryEntity.date = Calendar.current.date(byAdding: .day, value: -day, to: Date.now)
        currencyHistoryEntity.fromAmount = 5.1
        currencyHistoryEntity.fromCurrency = "USD"
        currencyHistoryEntity.toAmount = 100.2232323
        currencyHistoryEntity.toCurrency = "EGP"
        
        saveContext()
    }

    func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}
