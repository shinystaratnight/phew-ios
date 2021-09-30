//
//  FollowFriend.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/3/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation

struct FollowFriendModel: Codable {
    let isFollow: Bool?
    enum CodingKeys: String, CodingKey {
        case isFollow = "is_follow"
    }
}

