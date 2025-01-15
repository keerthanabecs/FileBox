//
//  FolderViewModel.swift
//  FileManager
//
//  Created by Keerthana on 13/01/25.
//
import Foundation

protocol FolderDelegate {
    func didFolderCreationSuccessfully(msg: String)
    func didFailed(msg: String)
    func didFolderColorChanged()
    func didFolderDeleted()
    func didFolderStarred()
}

class FolderViewModel {
    var delegate: FolderDelegate?
    var folderEntities: [FolderEntity] = []
    var selectedRow: Int!
    
    func createFolder(folderName: String) {
        let result = StorageHelper.createFolder(folderName: folderName)
        switch result {
        case .success(let folderPath):
            let date = Date()
            let (success, message) = CoreDataManager.sharedInstance.storeFolderDetails(name: folderName, path: folderPath, createdDate: date)
            if success {
                folderEntities = CoreDataManager.sharedInstance.fetchFolders()!
                delegate?.didFolderCreationSuccessfully(msg: "Folder Created successfully")
            } else {
                delegate?.didFailed(msg: message)
            }
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
            delegate?.didFailed(msg: errorMsg ?? "error")
        }
    }
    
    func fetchFolders() {
        if let folders = CoreDataManager.sharedInstance.fetchFolders() {
            folderEntities = folders
        }
    }
    
    func deleteFolder() {
        let folder = folderEntities[selectedRow]
        let result = StorageHelper.deleteFolder(folderName: folder.folderName ?? "")
        switch result {
        case .success(let folderPath):
            let (success, message) = CoreDataManager.sharedInstance.updateOrDeleteFolder(folderName: folder.folderName ?? "", folderPath: folder.folderPath ?? folderPath, menuType: .delete)
            if success {
                delegate?.didFolderDeleted()
            } else {
                delegate?.didFailed(msg: message)
            }
        case .failure(let error):
            var errorMsg: String?
            switch error {
            case .notAccess:
                errorMsg = "Could not access document directory"
            case .unknown:
                errorMsg = "An unknown error occured"
            case .folderNotFound:
                errorMsg = "Folder not found"
            }
            delegate?.didFailed(msg: errorMsg ?? "error")
        }
    }
    
    func updateFolderColor(color: String) {
        let folder = folderEntities[selectedRow]
        let (success, message) =  CoreDataManager.sharedInstance.updateOrDeleteFolder(folderName: folder.folderName ?? "", folderPath: folder.folderPath ?? "", menuType: .changeColor, color: color)
        if success {
            delegate?.didFolderColorChanged()
        } else {
            delegate?.didFailed(msg: message)
        }
    }
    func updateisFavorite() {
        let folder = folderEntities[selectedRow]
        let (success, message) =  CoreDataManager.sharedInstance.updateOrDeleteFolder(folderName: folder.folderName ?? "", folderPath: folder.folderPath ?? "", menuType: .starred, isFavorite: !folder.isFavorite)
        if success {
            delegate?.didFolderStarred()
        } else {
            delegate?.didFailed(msg: message)
        }
    }
    
}
