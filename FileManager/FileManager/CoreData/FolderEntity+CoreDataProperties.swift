//
//  FolderEntity+CoreDataProperties.swift
//  FileManager
//
//  Created by Keerthana on 16/01/25.
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
    @NSManaged public var files: NSSet?

}

// MARK: Generated accessors for files
extension FolderEntity {

    @objc(addFilesObject:)
    @NSManaged public func addToFiles(_ value: FileEntity)

    @objc(removeFilesObject:)
    @NSManaged public func removeFromFiles(_ value: FileEntity)

    @objc(addFiles:)
    @NSManaged public func addToFiles(_ values: NSSet)

    @objc(removeFiles:)
    @NSManaged public func removeFromFiles(_ values: NSSet)

}

extension FolderEntity : Identifiable {

}
