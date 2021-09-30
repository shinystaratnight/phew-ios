//
//  PhotoServices.swift
//  Smart Map
//
//  Created by Youssef on 3/30/20.
//  Copyright © 2020 Youssef. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit
//import AVFoundation

class PhotoServices: NSObject {
    
    static let shared = PhotoServices()
    
    var completion: ((Any) -> Void)?
    private let imagePicker = UIImagePickerController()
    
    override init() {
        super.init()
//        imagePicker.allowsEditing = true
        // imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String] //[kUTTypeMovie as String]
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func pickImageFromGalary(on: UIViewController, completion: @escaping (_ image: Any)->()) {
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.async {
            on.present(self.imagePicker, animated: true) {
                self.completion = completion
            }
        }
    }
}

// MARK: UIImagePickerControllerDelegate methods
extension PhotoServices: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    self.completion?(image)
                }
            }
        } else if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    self.completion?(image)
                }
            }
        } else if let videoURL = info[.mediaURL] as? URL {
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    self.completion?(videoURL)
                }
            }
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
    }
}

