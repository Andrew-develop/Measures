//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Andrew on 10.03.2023.
//
//

import Foundation
import CoreData

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var value: Data?
    @NSManaged public var info: String?
    @NSManaged public var angel: String?
    @NSManaged public var photoNote: Note?

}
