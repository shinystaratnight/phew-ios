//
//  LikePostDataModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/31/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

struct LikePostDataModel: Codable {
    let status, message: String?
    let data: LikePostModel?
}

// MARK: - DataClass
struct LikePostModel: Codable {
    var isLike: Bool?
    var likeType: String?
    enum CodingKeys: String, CodingKey {
        case isLike = "is_like"
        case likeType = "type"
    }
}
