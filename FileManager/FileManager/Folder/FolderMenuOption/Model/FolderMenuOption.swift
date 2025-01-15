//
//  FolderMenuOption.swift
//  FileManager
//
//  Created by Keerthana on 14/01/25.
//

import Foundation
import UIKit

struct MenuItem {
    let title: String
    let icon: UIImage
    let menuType: MenuType
}

enum MenuType {
    case delete
    case starred
    case changeColor
}
