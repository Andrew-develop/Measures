//
//  Parameter+CoreDataProperties.swift
//  
//
//  Created by Andrew on 10.03.2023.
//
//

import Foundation
import CoreData

extension Parameter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parameter> {
        return NSFetchRequest<Parameter>(entityName: "Parameter")
    }

    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var parameterMeasure: NSSet?
    @NSManaged public var parameterType: ParameterType?
    @NSManaged public var parameterUser: NSSet?

}

// MARK: Generated accessors for parameterMeasure
extension Parameter {

    @objc(addParameterMeasureObject:)
    @NSManaged public func addToParameterMeasure(_ value: Measurement)

    @objc(removeParameterMeasureObject:)
    @NSManaged public func removeFromParameterMeasure(_ value: Measurement)

    @objc(addParameterMeasure:)
    @NSManaged public func addToParameterMeasure(_ values: NSSet)

    @objc(removeParameterMeasure:)
    @NSManaged public func removeFromParameterMeasure(_ values: NSSet)

}

// MARK: Generated accessors for parameterUser
extension Parameter {

    @objc(addParameterUserObject:)
    @NSManaged public func addToParameterUser(_ value: User)

    @objc(removeParameterUserObject:)
    @NSManaged public func removeFromParameterUser(_ value: User)

    @objc(addParameterUser:)
    @NSManaged public func addToParameterUser(_ values: NSSet)

    @objc(removeParameterUser:)
    @NSManaged public func removeFromParameterUser(_ values: NSSet)

}
