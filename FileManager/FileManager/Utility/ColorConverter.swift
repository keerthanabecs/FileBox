//
//  ColorConverter.swift
//  FileManager
//
//  Created by Keerthana on 14/01/25.
//

import Foundation
import UIKit

class ColorConverter {
    
    static func colorToHex(color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255.0)), lroundf(Float(green * 255.0)), lroundf(Float(blue * 255.0)))
        return hexString
    }
}
