//
//  FileManagerPersistant.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 08.08.2024.
//

import UIKit

final class FileManagerPersistant {
    
    static func save(_ image: UIImage, with name: String) -> URL? {
        let data = image.jpegData(compressionQuality: 1)
        let url = getDocumentDerictory().appendingPathComponent(name)
        
        do {
            try data?.write(to: url)
            print("image was saved")
            return url
        } catch {
            print("saving image error \(error)")
            return nil
        }
    }
    
    static func read(from url: URL) -> UIImage? {
        UIImage(contentsOfFile: url.path)
    }
    
    static func delete(from url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("image was deleted")
        } catch {
            print("deleting image error \(error)")
        }
    }
    
    private static func getDocumentDerictory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
