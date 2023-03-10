//
//  User+CoreDataProperties.swift
//  
//
//  Created by Andrew on 10.03.2023.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var height: Double
    @NSManaged public var weight: Double
    @NSManaged public var gender: String?
    @NSManaged public var activityLevel: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var target: String?
    @NSManaged public var calorieIntake: Int64
    @NSManaged public var userNote: NSSet?
    @NSManaged public var userParameter: NSSet?

}

// MARK: Generated accessors for userNote
extension User {

    @objc(addUserNoteObject:)
    @NSManaged public func addToUserNote(_ value: Note)

    @objc(removeUserNoteObject:)
    @NSManaged public func removeFromUserNote(_ value: Note)

    @objc(addUserNote:)
    @NSManaged public func addToUserNote(_ values: NSSet)

    @objc(removeUserNote:)
    @NSManaged public func removeFromUserNote(_ values: NSSet)

}

// MARK: Generated accessors for userParameter
extension User {

    @objc(addUserParameterObject:)
    @NSManaged public func addToUserParameter(_ value: Parameter)

    @objc(removeUserParameterObject:)
    @NSManaged public func removeFromUserParameter(_ value: Parameter)

    @objc(addUserParameter:)
    @NSManaged public func addToUserParameter(_ values: NSSet)

    @objc(removeUserParameter:)
    @NSManaged public func removeFromUserParameter(_ values: NSSet)

}
