//
//  CurHistoryEntity+CoreDataProperties.swift
//  Currency_Bank_Misr_DF
//
//  Created by Mohamed Samir on 29/09/2022.
//
//

import Foundation
import CoreData



@objc(CurHistoryEntity)
public class CurHistoryEntity: NSManagedObject {

}


extension CurHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurHistoryEntity> {
        return NSFetchRequest<CurHistoryEntity>(entityName: "CurHistoryEntity")
    }

    @NSManaged public var toCurrency: String?
    @NSManaged public var toAmount: Double
    @NSManaged public var fromCurrency: String?
    @NSManaged public var fromAmount: Double
    @NSManaged public var date: Date?

}

extension CurHistoryEntity : Identifiable {

}
