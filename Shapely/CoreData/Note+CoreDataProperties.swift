//
//  Note+CoreDataProperties.swift
//  
//
//  Created by Andrew on 10.03.2023.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var noteUser: User?
    @NSManaged public var noteMeasure: NSSet?
    @NSManaged public var notePhoto: NSSet?

}

// MARK: Generated accessors for noteMeasure
extension Note {

    @objc(addNoteMeasureObject:)
    @NSManaged public func addToNoteMeasure(_ value: Measurement)

    @objc(removeNoteMeasureObject:)
    @NSManaged public func removeFromNoteMeasure(_ value: Measurement)

    @objc(addNoteMeasure:)
    @NSManaged public func addToNoteMeasure(_ values: NSSet)

    @objc(removeNoteMeasure:)
    @NSManaged public func removeFromNoteMeasure(_ values: NSSet)

}

// MARK: Generated accessors for notePhoto
extension Note {

    @objc(addNotePhotoObject:)
    @NSManaged public func addToNotePhoto(_ value: Photo)

    @objc(removeNotePhotoObject:)
    @NSManaged public func removeFromNotePhoto(_ value: Photo)

    @objc(addNotePhoto:)
    @NSManaged public func addToNotePhoto(_ values: NSSet)

    @objc(removeNotePhoto:)
    @NSManaged public func removeFromNotePhoto(_ values: NSSet)

}
