//
//  FolderViewModel.swift
//  FileManager
//
//  Created by Keerthana on 13/01/25.
//

import Foundation
             
class FolderViewModel {
    var folderEntities: [FolderEntity] = []
    
    func createFolder(folderName: String) {
        if let folderPath = StorageHelper.sharedInstance.createFolder(folderName: folderName) {
            let date = Date()
            CoreDataManager.sharedInstance.storeFolderDetails(name: folderName, path: folderPath, createdDate: date)
            folderEntities = CoreDataManager.sharedInstance.fetchFolders()!
        } else {
            print("Failed to create folder: \(folderName)")
        }
    }
}
