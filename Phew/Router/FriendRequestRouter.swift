//
//  FriendRequestRouter.swift
//  Phew
//
//  Created by Mohamed Akl on 9/7/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum FriendsRequestRouter: URLRequestConvertible {
    
    case listFriendsRequest(id: Int)
    case sendFriendRequest(id: Int)
    case cancelFriendRequest(id: Int)
    case acceptFriendRequest(id: Int)
    case rejectFriendRequest(id: Int)
    
    
    var method: HTTPMethod {
        switch  self {
        case .listFriendsRequest:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch  self {
        default:
            return nil
        }
    }
    
    var url: String {
        switch  self {
        case .listFriendsRequest(let id):
            return "users/\(id)/friend_request"
        case .sendFriendRequest(let id):
            return "users/\(id)/friend_request/send"
        case .cancelFriendRequest(let id):
            return "users/\(id)/friend_request/cancel"
        case .acceptFriendRequest(let id):
            return "users/\(id)/friend_request/accept"
        case .rejectFriendRequest(let id):
            return "users/\(id)/friend_request/reject"
        }
    }
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
