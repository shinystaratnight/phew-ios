//
//  FindalyRouter.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/24/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum FindalyRouter: URLRequestConvertible {
    case country
    case city(countryId: Int)
    case posts(countryId: Int, cityId: Int, page: Int)
    
    var method: HTTPMethod {
        switch self {
        case .country:
           return .get
        case .city:
          return .get
        case .posts:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .posts(_, _, let page):
            return ["page": page]
        default:
            return nil
        }
    }
    
    var url: String {
        switch self {
        case .country:
            return "findly/countries"
        case .city(let countryId):
            return "findly/countries/\(countryId)/cities"
        case .posts(countryId: let countryId, cityId: let cityId, _):
            return "findly/countries/\(countryId)/cities/\(cityId)"
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
