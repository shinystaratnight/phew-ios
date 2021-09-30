//
//  ImagePicker.swift
//  Phew
//
//  Created by Mohamed Akl on 6/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol PickerImageDelegate {
    func didPickedImage(image: UIImage, asset: String, tag: Int)
}

class PickImageVC: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: PickerImageDelegate!
    var picker = UIImagePickerController()
    var tag:Int = 0
    
    func pick(sender: UIImageView) {
        tag = sender.tag
        let alert:UIAlertController = UIAlertController(title: "Choose Picture",
                                                        message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = #colorLiteral(red: 0.368627451, green: 0.6666666667, blue: 0.737254902, alpha: 1)
        if let topController = UIApplication.topViewController() {
            print("topController\(topController)")
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
        
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Image Pick Management
    func openCamera() {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            //            if self.determineStatus(){
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            picker.cameraDevice = .front
            
            if let topController = UIApplication.topViewController() {
                print("topController\(topController)")
                //                    topController.navigationController!.popViewController(animated: true)
                topController.present(picker, animated: true, completion: nil)
            }
        }
            //        }
        else {
//                        let alertView = UIAlertView(title: "No Camera", message: "Sorry, this device has no camera", delegate:nil, cancelButtonTitle: nil, otherButtonTitles:  "OK")
//
//                        alertView.show()
        }
    }
    
    func openGallery() {
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        
        if let topController = UIApplication.topViewController() {
            print("topController\(topController)")
            //            topController.navigationController!.popViewController(animated: true)
            topController.present(picker, animated: true, completion: nil)
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        picker.navigationBar.barTintColor = #colorLiteral(red: 0.368627451, green: 0.6666666667, blue: 0.737254902, alpha: 1)
        picker.navigationBar.isTranslucent = false
        picker.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        picker.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        chosenImage = self.imageOrientation(chosenImage)
        var sendName = String()
        if let PHAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            print(PHAsset.value(forKey: "filename") as Any)
            sendName = "\(PHAsset.value(forKey: "filename") ?? "imageMX2.jpg")"
        }else{
            sendName = "imageMX2.jpg"
        }
        
        
        
        
        print(chosenImage)
        if delegate != nil{
            
            delegate.didPickedImage(image: chosenImage , asset: sendName, tag: tag )
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        default:
            break
        }
        
        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        default:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
}

extension UIApplication {

    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
