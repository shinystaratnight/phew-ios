//
//  followRouter.swift
//  Phew
//
//  Created by Mohamed Akl on 9/7/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum FollowtRouter: URLRequestConvertible {
    
    case followUnFollow(id: Int)
    case followers(id: Int)
    case followings(id: Int)
    
    var method: HTTPMethod {
        switch  self {
        case .followUnFollow:
            return .post
        default:
            return .get
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
        case .followUnFollow(let id):
            return "users/\(id)/follow"
        case .followers(let id):
            return "users/\(id)/followers"
        case .followings(let id):
            return "users/\(id)/followings"
        }
    }
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
