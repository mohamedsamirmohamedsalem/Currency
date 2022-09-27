//
//  AppDelegate.swift
//  Currency
//
//  Created by Mohamed Samir on 06/07/2022.
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

        let container = NSPersistentContainer(name: "Currency")
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
        
        addTestData()
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

    func addTestData() {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "HistoricalEntity", in: context)
        else { fatalError("could not find entity description")}
        
        let object = HistoricalEntity(entity: entity, insertInto: context)
        
        object.fromAmount =  3.0
        object.toAmount = 60.0
        object.fromCurrency = "egp"
        object.toCurrency = "dollar"
        object.date = Date.now
        
        saveContext()
        
        print("1111111111111111111")
        fetchData()
        print("1111111111111111111")
        
    }
    
    func fetchData(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoricalEntity")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let items = try context.fetch(fetchRequest)

            for item in items {
                print("item:::::: \(item)")
            }
            
        } catch  {
            print(error)
        }
    }
    func saveContext () {
        let context = persistentContainer.viewContext
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
