//
//  FriendsRouter.swift
//  Phew
//
//  Created by Mohamed Akl on 9/7/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum FriendsRouter: URLRequestConvertible {
    
    case listFriends(id: Int)
    case removeRequest(id: Int)
    
    var method: HTTPMethod {
        switch  self {
        case .listFriends:
            return .get
        case .removeRequest:
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
            
        case .listFriends(let id):
            return "users/\(id)/friends"
        case .removeRequest(let id):
            return "users/\(id)/friends/remove"
        }
    }
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
