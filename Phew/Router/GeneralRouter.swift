//
//  GeneralRouter.swift
//  Phew
//
//  Created by Mohamed Akl on 9/7/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

enum GeneralRouter: URLRequestConvertible {
    
    case about
    case terms
    case socialInfo
    case nationality
    case country
    case city(country: Int)
    case search
    case contactUs(parameters: [String: Any])
    case packages
    
    
    var method: HTTPMethod {
        switch self {
        case .contactUs:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .contactUs(let parameters):
            return parameters
        default:
            return nil
        }
    }
    
    var url: String {
        switch self {
        case .about:
            return "settings/about"
        case .terms:
            return "settings/conditions_terms"
        case .socialInfo:
            return "settings/social_info"
        case .nationality:
            return "nationalities"
        case .country:
            return "countries"
        case .city(let country):
            return "countries/\(country)/cities"
        case .search:
            return "search"
        case .contactUs:
            return "settings/contact"
        case .packages:
            return "packages"
        }
    }
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
