//
//  ChatRouter.swift
//  Phew
//
//  Created by Mohamed Akl on 9/7/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum ChatRouter: URLRequestConvertible {
    
    case conversation
    case show(id: Int)
    case send(id: Int, parameters: [String: Any])
    case delete(chatId: Int, messageId: Int)
    
    var method: HTTPMethod {
        switch  self {
        case .conversation,.show:
            return .get
        case .send:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var parameters: [String: Any]? {
        switch  self {
        case .send(_ , let parameters):
            return parameters
        default:
            return nil
        }
    }
    
    var url: String {
        switch  self {
        case .conversation:
            return "chats"
        case .show(let id):
            return "chats/\(id)"
        case .send(let id, _):
            return "chats/\(id)"
        case .delete(let chatId,let messageId):
            return "chats/\(chatId)/messages/\(messageId)"
        }
    }
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
