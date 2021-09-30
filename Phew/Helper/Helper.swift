//
//  HandelObject.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/11/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
    
    static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    static func covertStringToObject<T:Codable>(ofType:T.Type,value:String)->T?{
        
        let data = value.data(using: .utf8)!
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
            
        } catch {
            print(error)
            return nil
        }
    }
    
    static  func getArrayMedia(arrVideos:[Image]?, arrImages:[Image]?)->[HomePostNormalViewModel]{
        var arr = [HomePostNormalViewModel]()
        arrVideos?.forEach({
            arr.append(HomePostNormalViewModel(type: .video, coverImageVideo: $0.coverName, url: $0.data))
        })
        
        arrImages?.forEach({
            arr.append(HomePostNormalViewModel(type: .image, coverImageVideo: nil, url: $0.data))
        })
        
        return arr
    }
    
    static func getNameReact(tag: Int)  -> String {
        
        switch tag {
        case -1, 0:
            return "laugh"
        case 1:
            return "love"
        case 2:
            return "dislike"
        default:
            return "laugh"
        }
    }
   static func isMentionFriends(mentions:[User]?)->Bool{
        if let firends = mentions, firends.count > 0 {
            return true
        }else{
            return false
        }
    }
}
