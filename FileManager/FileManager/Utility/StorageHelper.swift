//
//  Untitled.swift
//  FileManager
//
//  Created by Keerthana on 12/01/25.
//
import Foundation


enum FolderCreationError: Error {
    case folderExists
    case notAccess
    case unknown
}

enum FolderDeletionError: Error {
    case notAccess
    case unknown
    case folderNotFound
}

class StorageHelper {
        
    static func createFolder(folderName: String) -> Result<String,FolderCreationError> {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not access Documents directory.")
            return .failure(.notAccess)
        }
        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        do {
            if !fileManager.fileExists(atPath: folderURL.path) {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                print("Folder created successfully at: ")
                return .success("\(folderURL.path)")
            } else {
                print("Folder already exists at: \(folderURL.path)")
                return .failure(.folderExists)
            }
        } catch {
            print("Error creating folder: \(error.localizedDescription)")
            return .failure(.unknown)
        }
    }
    
    static func deleteFolder(folderName: String)-> Result<String,FolderDeletionError> {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not access Documents directory.")
            return .failure(.notAccess)
        }
        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        do {
            if fileManager.fileExists(atPath: folderURL.path) {
                try fileManager.removeItem(at: folderURL)
                print("Folder Deleted successfully at: \(folderURL.path)")
                return .success("Folder Deleted successfully at: \(folderURL.path)")
            } else {
                print("Folder not found at: \(folderURL.path)")
                return .failure(.folderNotFound)
            }
        } catch {
            print("Error deleting folder \(error.localizedDescription)")
            return .failure(.unknown)
        }
    }
}
