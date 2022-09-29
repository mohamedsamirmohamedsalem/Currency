//
//  CurHistoryEntity+CoreDataProperties.swift
//  Currency
//
//  Created by Mohamed Samir on 28/09/2022.
//
//

import Foundation
import CoreData

public class CurHistoryEntity: NSManagedObject {

}

extension CurHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurHistoryEntity> {
        return NSFetchRequest<CurHistoryEntity>(entityName: "CurHistoryEntity")
    }

    @NSManaged public var fromCurrency: String?
    @NSManaged public var fromAmount: Double
    @NSManaged public var toAmount: Double
    @NSManaged public var toCurrency: String?
    @NSManaged public var date: Date?

}

extension CurHistoryEntity : Identifiable {

}
