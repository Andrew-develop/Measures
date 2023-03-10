//
//  ParameterType+CoreDataProperties.swift
//  
//
//  Created by Andrew on 10.03.2023.
//
//

import Foundation
import CoreData

extension ParameterType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParameterType> {
        return NSFetchRequest<ParameterType>(entityName: "ParameterType")
    }

    @NSManaged public var name: String?
    @NSManaged public var measure: String?
    @NSManaged public var typeParameter: NSSet?

}

// MARK: Generated accessors for typeParameter
extension ParameterType {

    @objc(addTypeParameterObject:)
    @NSManaged public func addToTypeParameter(_ value: Parameter)

    @objc(removeTypeParameterObject:)
    @NSManaged public func removeFromTypeParameter(_ value: Parameter)

    @objc(addTypeParameter:)
    @NSManaged public func addToTypeParameter(_ values: NSSet)

    @objc(removeTypeParameter:)
    @NSManaged public func removeFromTypeParameter(_ values: NSSet)

}
