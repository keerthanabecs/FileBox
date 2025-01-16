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

struct SortItem {
    let title: String
    let sortType: SortType
}

enum SortType: String {
    case nameAsc = "nameAsc"
    case nameDesc = "nameDesc"
    case dateAsc = "dateAsc"
    case dateDesc = "dateDesc"
}

class FolderViewModel {
    var delegate: FolderDelegate?
    var folderEntities: [FolderEntity] = []
    var selectedRow: Int!
    var sortMenu: [SortItem] = []
    var selectedSort: SortType?
    
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
    
    func fetchSortedFolder() {
        let (sort,asec)  = loadSortOption()
        if let folders = CoreDataManager.sharedInstance.fetchSortedFolder(sort: sort, asec: asec) {
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
    
    func loadSortMenu() {
        sortMenu = [
            SortItem(title: "Name A-Z", sortType: .nameAsc),
            SortItem(title: "Name Z-A", sortType: .nameDesc),
            SortItem(title: "Date (old to new)", sortType: .dateAsc),
            SortItem(title: "Date (new to old)", sortType: .dateDesc)
        ]
    }
    
    func loadSortOption() -> (sortBy: String, isAscending: Bool) {
        let defaults = UserDefaults.standard
        let sortTypeRawValue = defaults.string(forKey: "sortType") ?? SortType.dateAsc.rawValue
        let sortType = SortType(rawValue: sortTypeRawValue) ?? .dateAsc
        selectedSort = sortType
        if sortType == .dateAsc {
            return ("createdDate", true)
        } else if sortType == .dateDesc {
            return ("createdDate", false)
        } else if sortType == .nameAsc {
            return ("folderName", true)
        } else if sortType == .nameDesc {
            return ("folderName", false)
        } else{
            return ("folderName", true)
        }
    }
    
    func getTitle(for sortType: SortType) -> String? {
        if let sortItem = sortMenu.first(where: { $0.sortType == sortType }) {
            return sortItem.title
        }
        return nil
    }
}
