//
//  Measurement+CoreDataProperties.swift
//  
//
//  Created by Andrew on 10.03.2023.
//
//

import Foundation
import CoreData

extension Measurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurement> {
        return NSFetchRequest<Measurement>(entityName: "Measurement")
    }

    @NSManaged public var value: Double
    @NSManaged public var time: Date?
    @NSManaged public var measureNote: Note?
    @NSManaged public var measureParameter: Parameter?

}
