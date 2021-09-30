//
//  FavPostDataModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/30/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
struct FavPostDataModel: Codable {
    let status, message: String?
    let data: FavPostModel?
}

// MARK: - DataClass
struct FavPostModel: Codable {
    let isFav: Bool?

    enum CodingKeys: String, CodingKey {
        case isFav = "is_fav"
    }
}
