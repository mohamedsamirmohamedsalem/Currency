//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 26/09/2022.
//

import UIKit
import Foundation
import CoreData

protocol DatabaseManagerProtocol{
    
    var context: NSManagedObjectContext { get }
    func saveEntity<T: NSManagedObject>(entity: T)
    func deleteEntity<T: NSManagedObject>(entity: T)
    func fetchAllEntities<T>(entity: T) -> [NSFetchRequestResult]? where T : NSManagedObject
}

class DatabaseManager: DatabaseManagerProtocol{
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func saveEntity<T>(entity: T) where T : NSManagedObject {
        
        if context.hasChanges {
            do    {
                try context.save()
            }
            catch {
                print(error)
            }
        }
    }
    
    func deleteEntity<T>(entity: T) where T : NSManagedObject {
        context.delete(entity)
    }
    
    func fetchAllEntities<T>(entity: T) -> [NSFetchRequestResult]? where T : NSManagedObject {
        
        T.fetchRequest().returnsObjectsAsFaults = false

        do {
            let items = try context.fetch(T.fetchRequest())
            return items
        } catch  {
            print(error)
        }
        return nil
    }
}
