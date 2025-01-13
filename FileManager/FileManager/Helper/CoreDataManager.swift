//
//  CoreDataManager.swift
//  FileManager
//
//  Created by Keerthana on 12/01/25.

import CoreData
import UIKit

class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func storeFolderDetails(name: String, path: String, createdDate: Date) {
        let folder = FolderEntity(context: context)
        folder.folderName = name
        folder.folderPath = path
        folder.createdDate = createdDate
        folder.isFavorite = false
        do {
            try context.save()
            print("folder created successfully")
        } catch {
            print("failed: \(error.localizedDescription)")
        }
    }
    
    func fetchFolders() -> [FolderEntity]? {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        do {
            let folders = try context.fetch(fetchRequest)
            return folders
        } catch {
            print("Error fetching folders: \(error)")
            return nil
        }
    }
    
    
    
}


