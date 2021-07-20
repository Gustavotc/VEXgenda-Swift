//
//  ImageManager.swift
//  Agenda
//
//  Created by INDB on 09/07/21.
//

import Foundation
import UIKit

class ImageManager {
    
    static func savePhoto(photo: UIImage?, name: String) throws -> String? {
        guard let photo = photo else { return nil}

        let fileManager = FileManager.default

        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderPath = documentDirectory.appendingPathComponent("/Contacts")

        //Create folder
        if !fileManager.fileExists(atPath: folderPath.relativePath) {
            do {
                try fileManager.createDirectory(atPath: folderPath.relativePath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                return nil
            }

        }

        //Default Image
        let filePath = folderPath.appendingPathComponent(name)
        let data = photo.jpegData(compressionQuality: 1.0)
        do {
            try data?.write(to: filePath)
        } catch {
            return nil
        }

        return name
    }
    
    static func findImageWithName(name: String?) -> UIImage? {
        guard let name = name else { return nil }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderPath = documentsDirectory.appendingPathComponent("/Contacts")
        let filePath = folderPath.appendingPathComponent(name)

        var image = UIImage(contentsOfFile: filePath.relativePath)
        if image == nil {
            image = UIImage(named: name)
        }

        return image

    }
    
}
