//
//  FolderViewModel.swift
//  FileManager
//
//  Created by Keerthana on 13/01/25.
//
import Foundation

protocol FolderCreationDelegate {
    func didFolderCreationSuccessfully(msg: String)
    func didFolderCreationFailed(msg: String)
}

class FolderViewModel {
    var delegate: FolderCreationDelegate?
    var folderEntities: [FolderEntity] = []
    
    func createFolder(folderName: String) {
        let result = StorageHelper.createFolder(folderName: folderName)
        switch result {
        case .success(let folderPath):
            let date = Date()
            CoreDataManager.sharedInstance.storeFolderDetails(name: folderName, path: folderPath, createdDate: date)
            folderEntities = CoreDataManager.sharedInstance.fetchFolders()!
            delegate?.didFolderCreationSuccessfully(msg: "Folder Created successfully")
        case .failure(let error):
            var errorMsg: String?
            switch error {
            case .folderExists:
                errorMsg = "Folder already exists"
            case .notAccess:
                errorMsg = "Could not access document directory"
            case .unknown:
                errorMsg = "An unknown error occured"
            }
            delegate?.didFolderCreationFailed(msg: errorMsg ?? "error")
        }
    }
    
    func fetchFolders() {
        if let folders = CoreDataManager.sharedInstance.fetchFolders() {
            folderEntities = folders
        }
    }
}
