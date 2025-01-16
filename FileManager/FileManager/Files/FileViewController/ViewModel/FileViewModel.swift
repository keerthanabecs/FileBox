//
//  FileViewModel.swift
//  FileManager
//
//  Created by Keerthana on 16/01/25.
//

import Foundation
import UIKit
import CoreData

class FileViewModel {
    var folder: FolderEntity?
    var files: [FileEntity] = []
    
    var updateFilesView: (() -> Void)?
    
    init(folder: FolderEntity?) {
        self.folder = folder
    }
    
    func savePickedImage(image: UIImage, fileName: String, completion: @escaping (Bool, String) -> Void) {
        let folderName = folder!.folderName ?? ""
        let fileURL = StorageHelper.saveImageToSpecificFolder(image: image, folderName: folderName, fileName: fileName)
        if fileURL != nil {
            let (success, message) = CoreDataManager.sharedInstance.storeFileDetails(name: fileName, folder: folder!, path: fileURL?.absoluteString ?? "Test1", createdDate: Date())
            completion(success, message)
        } else {
            completion(false, "FilePath Empty")
        }
    }
    
    func fetchFiles(folderName: String) {
        files = CoreDataManager.sharedInstance.fetchFiles(for: folderName)
    }
}
