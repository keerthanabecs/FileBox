//
//  FolderMenuViewModel.swift
//  FileManager
//
//  Created by Keerthana on 14/01/25.
//

import Foundation
import UIKit

class FolderMenuViewModel {
    var folder: FolderEntity?
    var menus: [MenuItem] = []
    
    func loadMenus() {
        menus = [
            MenuItem(title: "Favorite", icon: UIImage(systemName: "star")!, menuType: .starred),
            MenuItem(title: "Change Color", icon: UIImage(systemName: "paintbrush")!, menuType: .changeColor),
            MenuItem(title: "Delete", icon: UIImage(systemName: "trash")!, menuType: .delete)
        ]
    }
}

