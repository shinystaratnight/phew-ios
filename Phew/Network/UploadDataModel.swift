//
//  UploadDataModel.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

struct UploadData {
    var data: Data? = nil
    var url: URL? = nil
    let fileName: String
    let mimeType: String
    let name: String
    
    init(data: Data,
         name: String = "image",
         fileName: String = "image.jpeg",
         mimeType: String = "image/jpeg"
        ) {
        
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
        self.name = name
    }
    
    init(image: UIImage, name: String) {
        self.data = image.jpegData(compressionQuality: 0.5)!
        self.name = name
        self.fileName = "\(name).jpeg"
        self.mimeType = "\(name)/jpeg"
    }
    
    init(url: URL, name: String) {
        self.url = url
        self.name = name
        self.fileName = ""
        self.mimeType = ""
    }
    
    init(image: UIImage,
         name: String = "image",
         fileName: String = "image.jpeg",
         mimeType: String = "image/jpeg"
        ) {
        
        self.data = image.jpegData(compressionQuality: 0.5)!
        self.fileName = fileName
        self.mimeType = mimeType
        self.name = name
    }
}
