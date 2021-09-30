//
//  AuthRouter.swift
//  Phew
//
//  Created by Youssef on 9/3/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    typealias parameters = [String: Any]
    
    case login(_ parameters: parameters)
    case register(_ parameters: parameters)
    case verify(_ parameters: parameters)
    case forgetPassword(_ parameters: parameters)
    case restPassword(paramter:parameters)
    case resendCode(_ paramter:parameters)
    case logout
    case loginSocial(_ parameters: parameters)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .login(let parameters), .register(let parameters), .verify(let parameters):
            return parameters
        case .forgetPassword(let parameters), .restPassword(let parameters), .resendCode(let parameters):
            return parameters
        case .logout:
            return ["device_type": "ios", "device_token": FirebaseMessagingManger.firebaseMessagingToken]
        case .loginSocial(parameters: let parameters):
            return parameters
        }
    }
    
    var url: String {
        switch self {
        case .login:
            return "auth/login"
        case .register:
            return "auth/register"
        case .verify:
            return "auth/verify"
        case .forgetPassword:
            return "auth/forgot_password"
        case .restPassword:
            return "auth/reset_password"
        case .resendCode:
            return "auth/resend/code"
        case .logout:
            return "auth/logout"
        case .loginSocial :
            return "auth/social_login"
        }
    }
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
