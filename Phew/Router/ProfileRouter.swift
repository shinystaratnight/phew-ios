//
//  ProfileRouter.swift
//  Phew
//
//  Created by Mohamed Akl on 9/7/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum ProfileRouter: URLRequestConvertible {
    
    case profile(id: Int)
    case updateProfile(parameters: [String: Any])
    case updateSetting(parameters: [String: Any])
    case updatePassword(parameters: [String: Any])
    case block(id: Int, parameters: [String: Any])
    case posts(userId: Int, type: String, page: Int)
    case deleteSelectedImageProfile(id: Int)
    case subscribePackage(id: Int)
    var method: HTTPMethod {
        switch self {
        case .profile:
            return .get
        case .posts:
            return .get
        case .deleteSelectedImageProfile:
            return .delete
        case .subscribePackage:
            return .put
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .updateProfile(let parameters), .updateSetting(let parameters):
            return parameters
        case .updatePassword(let parameters), .block(_, let parameters):
            return parameters
        case .posts(  _, let type, let page):
            return ["type":type, "page": page]
        default:
            return nil
        }
    }
    
    var url: String {
        switch self {
        case .profile(let id):
            return "users/\(id)"
        case .updateProfile:
            return "auth/update_profile"
        case .updateSetting:
            return "auth/update_setting"
        case .updatePassword:
            return "auth/update_password"
        case .block(let id, _):
            return "users/\(id)/block"
        case .posts(userId: let userId, _, _):
            return "users/\(userId)/posts"
        case .deleteSelectedImageProfile(let id):
           return "auth/image/\(id)"
        case .subscribePackage(id: let id):
            return "auth/subscribe_pacakge/\(id)"
        }
    }
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
    
    var encoding: ParameterEncoding{
        switch self {
        case .posts:
            return URLEncoding(destination: .queryString)
        default:
            return JSONEncoding.default
        }
    }
}
