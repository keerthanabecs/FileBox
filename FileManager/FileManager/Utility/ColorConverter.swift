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
    
    static func hexToColor(hex: String, alpha: CGFloat = 1.0) -> UIColor? {
        var trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedHex = trimmedHex.replacingOccurrences(of: "#", with: "")
        guard trimmedHex.count == 6 else {
            print("Invalid hex code: \(hex)")
            return nil
        }
        var rgb: UInt64 = 0
        let scanner = Scanner(string: trimmedHex)
        guard scanner.scanHexInt64(&rgb) else {
            print("Failed to scan hex code \(trimmedHex)")
            return nil
        }
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
