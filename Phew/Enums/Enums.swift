//
//  Enums.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/10/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation


enum PostTypeEnum {
    case first
    case withComment
    case withoutComment
   
    var name:String {
        switch  self {
        case .first:
            return "first"
        case .withComment:
            return "echo_with_comment"
        case .withoutComment:
            return "echo_without_comment"
        }
    }
}

enum ActiviTypeEnum {
    case normal
    case location
    case watching
    var name:String {
        switch  self {
        case .normal:
            return "normal"
        case .location:
            return "location"
        case .watching:
            return "watching"
        }
    }
}

enum PostEnum {
    case normal
    case location
    case watching
    case sharePost
    case ShareText
    case shareLocation
    case shareWatch
    case sponsor
    case secretMessage
}

enum HomeDataTypeEnum: String {
    case post = "post"
    case sponsor = "sponsor"
    case secretMessage = "secret_message"
}


enum PostsVCs: Equatable {
    case home
    case userProfile
    case findaly(countryId:Int, cityId: Int)
}

enum NotificationKeys: String{
    case management = "management_message"
    case retweet = "retweeted_post"
    case follow = "follow"
    case friendRequest = "new_friend_request"
    case comment = "comment"
    case like = "like"
}
