//
//  AddEditViewModel.swift
//  Agenda
//
//  Created by INDB on 06/07/21.
//

import Foundation
import UIKit

protocol AddEditViewModelDelegate: AnyObject {
    func addContactPhoto(photo: UIImage?)
}

class AddEditViewModel: NSObject {
    
    var phones: [Phone] = []
    weak var delegate: AddEditViewModelDelegate!
    
    func addPhone(phoneNumber: String, type: String) {
        let phone = Phone()
        phone.phone = phoneNumber
        phone.type = type
        phones.append(phone)
    }
    
    func getPhones() -> [Phone] {
        return self.phones
    }
    
    func clearPhones() {
        self.phones = []
    }
    
    func removePhone(at indexPath: Int) {
        
        if phones.count >= indexPath {
            self.phones.remove(at: indexPath)
        }
        
    }
        
}

extension AddEditViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let originalWidth = image.size.width
            let aspectRatio = originalWidth/image.size.height
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
            } else {
                smallSize = CGSize(width: 1000 * aspectRatio, height: 1000)
            }

            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            picker.dismiss(animated: true, completion: nil)
            
            delegate.addContactPhoto(photo: smallImage)
            
        }
    }
}
