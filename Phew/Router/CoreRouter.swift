//
//  CoreRouter.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/9/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire
enum CoreRouter: URLRequestConvertible {
    
    case home(type: String, page: Int)
    case postNormal(text:String?, isFindaly: Int, privacy: String)
    case postWatch(watching:String, firends:String?, privacy: String)
    case postLocation(location:String, firends:String?, privacy: String)
    case shareWithoutComment(postId:Int, privacy: String)
    case shareWithComment(postId:Int,text:String?)
    case searchFriends(text:String)
    case favourit(postId: Int)
    case listCommnet(postId:Int)
    case addCommnet(text:String?,postId:Int)
    case like(postId: Int, type: String?)
    case screenShot(postId: String)
    case deletePost(postId: Int)
    case findaly(postid: Int)
    case updateFindlay(postId: Int, privacy: String)
    case updatePost(id: Int, text: String)
    case hideAdv(id: Int)
    case getPost(postId: Int)
    
    var method: HTTPMethod{
        switch self {
        case .postNormal, .postWatch, .postLocation, .shareWithoutComment, .shareWithComment:
            return .post
        case .addCommnet:
            return .post
        case .favourit:
            return .post
        case .like:
            return .post
        case .screenShot:
            return .post
        case .deletePost:
            return .delete
        case .findaly:
            return .post
        case .updateFindlay:
            return .post
        case .updatePost:
            return .post
        case .hideAdv:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]?{
        switch  self {
        case .home(let type, let page):
            return [ "page" : page, "type":type]
        case .postNormal(let text, let isFindaly, let privacy):
            var body:[String:Any] = ["post_type":"first", "activity_type":"normal", "show_privacy": privacy, "show_in_findly": isFindaly]
            if let post = text , !post.isEmpty {
                body["text"] = post
            }
            return body
            
        case let .searchFriends(text):
            return ["fullname":text]
            
        case let .postWatch(watching, firends,  privacy):
            var body = ["post_type":"first", "activity_type":"watching", "watching":"\(watching)", "show_privacy": privacy] as [String : Any]
            if let _friends = firends {
                body["friends_with"] = _friends
            }
            return body
            
        case let .postLocation(location, firends, privacy):
            var body = ["post_type":"first", "activity_type":"location", "location":"\(location)", "show_privacy": privacy]
            if let _friends = firends {
                body["friends_with"] = _friends
            }
            return body
        case let .shareWithoutComment(postId, privacy):
            return ["post_type":"echo_without_comment", "activity_type":"normal","post_id":postId, "show_privacy": privacy]
            
        case let .shareWithComment(postId, text):
            var postType: String = "echo_without_comment"
            var body :[String:Any] = [ "activity_type":"normal","show_privacy": "all","post_id":postId]
            if let post = text , !post.isEmpty {
                body["text"] = post
                postType = "echo_with_comment"
            }
            body["post_type"] = postType
            return body
            
        case .addCommnet(let text, _):
            if let commment = text , commment.count > 0 {
                return ["text": commment]
            }else{
                return nil
            }
        case .like( _, let type):
            if let _type = type {
                return ["type" : _type]
            }else{
                return nil
            }
        case .screenShot(let posts):
            return ["posts":  posts]
        case .updateFindlay( _, let privacy):
            return ["_method": "PUT", "show_privacy": privacy]
        case .updatePost(_, let text):
            return ["_method": "PUT", "text": text]
        default:
            return nil
            
        }
    }
    
    var url: String{
        switch self {
        case .home(_, _):
            return "posts"
        case .postNormal , .postWatch, .postLocation, .shareWithoutComment, .shareWithComment:
            return "posts"
            
        case .searchFriends:
            return "search"
            
        case .listCommnet(let id):
            return "posts/\(id)/comments"
        case .addCommnet( _ , let id):
            return "posts/\(id)/comments"
        case .favourit(let postId):
            return "posts/\(postId)/fav"
        case .like(postId: let postId, type: _):
            return "posts/\(postId)/like"
            
        case .screenShot:
            return "screen_shot"
        case .deletePost(postId: let postId):
            return "posts/\(postId)"
        case .findaly(postid: let postid):
            return "posts/\(postid)/findly".trimmedString
        case .updateFindlay(let id , _):
            return "posts/\(id)/update_privacy"
        case .updatePost(id: let id, text: _):
            return "posts/\(id)"
        case .hideAdv(id: let id):
            return "hide_ad/\(id)"
            
        case .getPost(postId: let postId):
            return "posts/\(postId)"
        }
    }
    
    var encoding: ParameterEncoding{
        switch self {
        case .searchFriends, .home:
            return URLEncoding(destination: .queryString)
        default:
            return JSONEncoding.default
        }
    }
    
    var baseUrl: String {
        switch self {
        default:
            return  Constants.baseUrl
        }
    }
}
