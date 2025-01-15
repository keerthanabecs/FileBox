//
//  FolderMenuViewModel.swift
//  FileManager
//
//  Created by Keerthana on 14/01/25.
//

import Foundation
import UIKit

protocol MenuViewModelDelegate {
    func didSelectMenu(menu: MenuType)
}

class FolderMenuViewModel {
    var delegate: MenuViewModelDelegate?
    var menus: [MenuItem] = []
    var folderEntity: FolderEntity?
    
    func loadMenus() {
        menus = [
            MenuItem(title: "Favorite", icon: UIImage(systemName: "star")!, menuType: .starred),
//            MenuItem(title: "Rename", icon: UIImage(systemName: "pencil")!, menuType: .rename),
            MenuItem(title: "Change Color", icon: UIImage(systemName: "paintbrush")!, menuType: .changeColor),
            MenuItem(title: "Delete", icon: UIImage(systemName: "trash")!, menuType: .delete)
        ]
    }
    func selectMenu(index: Int) {
        let menu = menus[index].menuType
    }
    
    func updateFolder(folderName: String, folderPath: String, menutype: MenuType) {

        
    }

    
}
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
