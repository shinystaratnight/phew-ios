//
//  FollowDataModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
struct FollowDataModel: BaseCodable {
    var status: String?
    var message: String?
    let data: FollowModel?
}

// MARK: - DataClass
struct FollowModel: Codable {
    let isFollow: Bool?

    enum CodingKeys: String, CodingKey {
        case isFollow = "is_follow"
    }
}
