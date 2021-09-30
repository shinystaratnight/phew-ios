//
//  NotificationRouter.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/22/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//


import Alamofire

enum NotificationRouter: URLRequestConvertible {
   
    
    case fetchNotification
    case deleteNotification(id: String)
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotification:
            return .get
        case .deleteNotification:
            return .delete
        }
    }
    
    var parameters: [String : Any]?{
        switch self {
        case .fetchNotification:
            return nil
        case .deleteNotification:
            return nil
        }
    }
    
    var url: String{
        switch self {
        case .fetchNotification:
            return "notifications"
        case .deleteNotification(let id):
            return "notifications/\(id)"
        }
    }
    
    var baseUrl: String{
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
