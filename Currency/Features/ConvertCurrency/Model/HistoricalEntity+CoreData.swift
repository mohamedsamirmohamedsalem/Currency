//
//  HistoricalConversionEntity+CoreDataProperties.swift
//  Currency
//
//  Created by Mohamed Samir on 26/09/2022.
//
//


import Foundation
import CoreData

public class HistoricalEntity: NSManagedObject {


}


extension HistoricalEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalEntity> {
        return NSFetchRequest<HistoricalEntity>(entityName: "HistoricalEntity")
    }
    
    @NSManaged public var fromCurrency: String
    @NSManaged public var toCurrency: String
    @NSManaged public var fromAmount: Double
    @NSManaged public var toAmount: Double
    @NSManaged public var date: Date
}

extension HistoricalEntity : Identifiable {

}

