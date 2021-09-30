//
//  SecretMessageRouter.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/25/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum SecretMessageRouter: URLRequestConvertible {
    case endMessage(userId: Int, message: String)
    case list
    case delete(messageId: Int)
    case reply(text: String?, messageId: Int)
    case show(messageId: Int)
    
     var method: HTTPMethod {
        switch self {
        case .endMessage:
            return .post
        case .list:
            return .get
        case .delete:
            return .delete
        case .show:
            return .get
        case .reply:
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .endMessage(_, message):
            return ["message": message]
        case .list:
            return nil
        case .delete:
            return nil
        case .show:
            return nil
        case .reply(let text, _):
            var body:[String:Any] = ["post_type":"echo_without_comment", "activity_type":"normal"]
            if let post = text , !post.isEmpty {
                body["text"] = post
            }
            return body
        }
    }
    
    var url: String{
        switch self {
        case .endMessage(let userId, _):
            return "users/\(userId)/secret_message"
        case .list:
            return "secret_message"
        case .delete(messageId: let messageId):
            return "secret_message/\(messageId)"
        case .show(messageId: let messageId):
            return "secret_message/\(messageId)"
        case .reply(_, let messageId):
            return "secret_message/\(messageId)"
        }
    }
    
    var baseUrl: String{
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
