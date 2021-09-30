//
//  APIRouter.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/28/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire
enum APIRouter: URLRequestConvertible {
    case filmMovi(text:String,page:Int)
    case searchGooglePlaces(text:String)
    case fetchMoviePopular
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var url: String {
        switch self {
        case .filmMovi(let text, let page):
            return "\(text)&page=\(page)&include_adult=false"
            
            
        case let .searchGooglePlaces(text):
            return "\(text)&inputtype=textquery&fields=formatted_address,name&key=\(Constants.googleMapKey)"
        case .fetchMoviePopular:
            return "movies"
        }
    }
    var baseUrl: String {
        switch self {
        case .filmMovi:
            return "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.moviFilmKey)&language=en-US&query="
        case .searchGooglePlaces:
            return "https://maps.googleapis.com/maps/api/place/textsearch/json?input="
        case .fetchMoviePopular:
            return Constants.baseUrl
        }
    }
}
