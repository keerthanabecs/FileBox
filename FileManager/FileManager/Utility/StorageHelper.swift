//
//  Untitled.swift
//  FileManager
//
//  Created by Keerthana on 12/01/25.
//
import Foundation

class StorageHelper {
        
    static func createFolder(folderName: String) -> String? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not access Documents directory.")
            return ""
        }
        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        do {
            if !fileManager.fileExists(atPath: folderURL.path) {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                print("Folder created successfully at: ")
                return "\(folderURL.path)"
            } else {
                print("Folder already exists at: \(folderURL.path)")
            }
        } catch {
            print("Error creating folder: \(error.localizedDescription)")
        }
        return ""
    }
}
