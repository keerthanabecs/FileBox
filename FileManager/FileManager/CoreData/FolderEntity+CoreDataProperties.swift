//
//  FolderEntity+CoreDataProperties.swift
//  FileManager
//
//  Created by Keerthana on 13/01/25.
//
//

import Foundation
import CoreData


extension FolderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderEntity> {
        return NSFetchRequest<FolderEntity>(entityName: "FolderEntity")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var folderColor: String?
    @NSManaged public var folderName: String?
    @NSManaged public var folderPath: String?
    @NSManaged public var isFavorite: Bool

}

extension FolderEntity : Identifiable {

}
