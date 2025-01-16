//
//  FileEntity+CoreDataProperties.swift
//  FileManager
//
//  Created by Keerthana on 16/01/25.
//
//

import Foundation
import CoreData


extension FileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FileEntity> {
        return NSFetchRequest<FileEntity>(entityName: "FileEntity")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var fileName: String?
    @NSManaged public var filePath: String?
    @NSManaged public var fileType: String?
    @NSManaged public var folder: FolderEntity?

}

extension FileEntity : Identifiable {

}
