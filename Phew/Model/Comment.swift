//
//  Comment.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/22/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

struct CommentData: BaseCodable {
    var status: String?
    
    var message: String?
  
    let data: [CommentModel]?
}

// MARK: - Datum
struct CommentModel: Codable {
    let id: Int?
    let text: String?
    let images: [Image]?
    let user: User?
    let postable: Postable?
}

// MARK: - Image


