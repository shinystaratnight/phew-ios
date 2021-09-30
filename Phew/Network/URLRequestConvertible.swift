//
//  URLRequestConveritble.swift
//  Torch
//
//  Created by Youssef on 8/11/19.
//  Copyright © 2019 Youssef. All rights reserved.
//

import Foundation
import Alamofire

protocol URLRequestConvertible: Alamofire.URLRequestConvertible {
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var url: String { get }
    var encoding: ParameterEncoding { get }
    var baseUrl: String {get}
    
}

extension URLRequestConvertible {
        
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest :URLRequest
        
//        if !url.contains("https"){
        let _url = "\(baseUrl)\(url)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(_url)
//            urlRequest = URLRequest(url: URL(string: baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!.appendingPathComponent(url))
        urlRequest = URLRequest(url:URL(string: _url)!)
            print(urlRequest)
                
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}
