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
    
    func loadMenus() {
        menus = [
            MenuItem(title: "Favorite", icon: UIImage(systemName: "star")!, menuType: .starred),
            MenuItem(title: "Rename", icon: UIImage(systemName: "pencil")!, menuType: .rename),
            MenuItem(title: "Change Color", icon: UIImage(systemName: "paintbrush")!, menuType: .changeColor),
            MenuItem(title: "Delete", icon: UIImage(systemName: "trash")!, menuType: .delete)
        ]
    }
    func selectMenu(index: Int) {
        let menu = menus[index].menuType
        delegate?.didSelectMenu(menu: menu)
    }
}
