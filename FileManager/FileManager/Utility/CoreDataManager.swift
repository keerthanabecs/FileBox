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
    
    func storeFolderDetails(name: String, path: String, createdDate: Date) -> (Bool, String) {
        let folder = FolderEntity(context: context)
        let colorString = ColorConverter.colorToHex(color: .gray)
        folder.folderName = name
        folder.folderPath = path
        folder.createdDate = createdDate
        folder.isFavorite = false
        folder.folderColor = colorString
        do {
            try context.save()
            print("folder created successfully")
            return (true,"")
        } catch {
            print("failed: \(error.localizedDescription)")
            return (false, error.localizedDescription)
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
    
    func updateOrDeleteFolder(folderName: String, folderPath: String, menuType: MenuType, isFavorite: Bool = false, color: String = "") -> (Bool, String) {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "folderName == %@ AND folderPath == %@", folderName,folderPath)
        do {
            let folder = try context.fetch(fetchRequest)
            if let folderToUpdate = folder.first {
                if menuType == .changeColor {
                    folderToUpdate.folderColor = color
                } else if menuType == .starred {
                    folderToUpdate.isFavorite = isFavorite
                } else if menuType == .delete {
                    context.delete(folderToUpdate)
                    print("folder deleted successFully")
                }
                try context.save()
                return(true, "")
            } else {
                print("folder not found")
                return(false, "Folder not found")
            }
        } catch {
            print("Error updating folder: \(error.localizedDescription)")
            return(false, error.localizedDescription)
        }
    }
}


