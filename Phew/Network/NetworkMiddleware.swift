//
//  NetworkMiddleware.swift
//  Torch
//
//  Created by Youssef on 8/11/19.
//  Copyright © 2019 Youssef. All rights reserved.
//

import Foundation
import Alamofire

class NetworkMiddleware: RequestAdapter {
    
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        #if Debug
        // print(configuration.httpAdditionalHeaders)
        // print(SessionManager.defaultHTTPHeaders)
        #endif
        // configuration.httpAdditionalHeaders = ["os": "ios"]
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        return SessionManager(configuration: configuration)
    }()
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
         urlRequest.setValue("ar", forHTTPHeaderField: "lang")
        // urlRequest.setValue("os", forHTTPHeaderField: "ios")
         urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Content-Length", forHTTPHeaderField: "1000")
        
        
        if let token = AuthService.userData?.token?.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           
        }
        
        return urlRequest
    }
}
