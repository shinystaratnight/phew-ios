//
//  HomeProtocol.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/11/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit
protocol HomePresenterProtocol {
    func getCellType(postType:String, activityType:String, activityTypeShare:String?, type: String, postableType: String)->PostEnum
    func getCellHeight(model:HomeModel, activityTypeShare: String?, type: String, isFullPost: Bool)->CGFloat
    func getPostable(post: HomeModel) -> HomeModel
    func getPostType(post: inout HomeModel, type: String, isFullPost: Bool) -> (postId: Int, postType: PostEnum, post: HomeModel, height: CGFloat)
    func getPostShare(post: inout HomeModel, type: String) -> (postId: Int, postType: PostEnum, post: HomeModel, height: CGFloat)
}

class HomePresenter:HomePresenterProtocol{
    
    private var viewWidth:CGFloat
    init(viewWidth:CGFloat) {
        self.viewWidth = viewWidth
    }
    func getCellType(postType:String, activityType:String, activityTypeShare:String?, type: String, postableType: String)->PostEnum{
        
        guard type == HomeDataTypeEnum.post.rawValue else {return  PostEnum.sponsor}
        if postableType == HomeDataTypeEnum.secretMessage.rawValue {
            return  PostEnum.secretMessage
        }
        //        guard postableType == HomeDataTypeEnum.secretMessage.rawValue else {}
        // first and normal
        if postType == PostTypeEnum.first.name && activityType ==  ActiviTypeEnum.normal.name {
            return PostEnum.normal
            
            // location
        }else if postType == PostTypeEnum.first.name && activityType ==  ActiviTypeEnum.location.name{
            return PostEnum.location
            
            // watching
        }else if postType == PostTypeEnum.first.name && activityType ==  ActiviTypeEnum.watching.name{
            return PostEnum.watching
            
            //get share cell type 
        }else if postType == PostTypeEnum.withComment.name && activityType ==  ActiviTypeEnum.normal.name {
            return .sharePost
        } else if postType == PostTypeEnum.withoutComment.name && activityType ==  ActiviTypeEnum.normal.name {
            return .ShareText
        }
        else{
            return PostEnum.normal
        }
    }
    
    private func getShareCellType(activityTypeShare:String?)->PostEnum{
        switch activityTypeShare {
        case ActiviTypeEnum.normal.name:
            return PostEnum.sharePost
        case ActiviTypeEnum.location.name:
            return PostEnum.shareLocation
        case ActiviTypeEnum.watching.name:
            return PostEnum.shareWatch
        default :
            return PostEnum.normal
        }
    }
    
    func getCellHeight(model:HomeModel, activityTypeShare: String?, type: String, isFullPost: Bool)->CGFloat{
        var height:CGFloat = 0.0
        let countVideo = model.videos?.count ?? 0
        let countImages = model.images?.count ?? 0
        let totalPostMedia = countVideo + countImages
        
        guard let postType = model.postType, let activity =  model.activityType else{return 0}
        let cellType = getCellType(postType: postType, activityType: activity, activityTypeShare: activityTypeShare, type: type, postableType: model.postableType ?? "")
        switch  cellType {
        
        case .normal:
            var textHeight: CGFloat = 0
            if isFullPost {
                let text = (model.text ?? "")
                textHeight = detectTextHeihgt(text: text, numberChar: text.count + 1)
            }else{
                textHeight = detectTextHeihgt(text: (model.text ?? ""), numberChar: 300)
            }
            
            height = totalPostMedia > 0 ? (250 + textHeight)  :  (115 + 25) + textHeight
            return height + 15
            
        case .location:
            let mentions = model.mentions?.count ?? 0
            return mentions > 0 ? 80 : 60
            
        case .watching:
            return 90
            
        case .sharePost:
            height = 180 //175
            var textHeightReply: CGFloat = 0
            var textHeightPost: CGFloat = 0
            
            let replyVideoCount = model.postable?.videos?.count ?? 0
            let replyImagesCount = model.postable?.images?.count ?? 0
            if isFullPost {
                let text = (model.text ?? "")
                textHeightReply = detectTextHeihgt(text: text, numberChar: text.count + 1)
            }else{
                let countCharacter = AuthService.userData?.subscribeData?.package?.plan?.charactersPostCount ?? "300"
                textHeightReply = detectTextHeihgt(text: (model.text ?? ""), numberChar: Int(countCharacter) ?? 0)
            }
            
            textHeightPost =  detectTextHeihgt(text: model.postable?.text ?? "", numberChar: 50)
            let totalReplyMedia = replyVideoCount + replyImagesCount
            height += (textHeightPost + textHeightReply)
            height += totalPostMedia > 0 ? 120 : 0
            height += totalReplyMedia > 0 ? 130 : 0
            return (height)
            
        case .ShareText:
            height = 180 //175
            var textHeightReply: CGFloat = 0
            var textHeightPost: CGFloat = 0
            
            let replyVideoCount = model.postable?.videos?.count ?? 0
            let replyImagesCount = model.postable?.images?.count ?? 0
            if isFullPost {
                let text = (model.text ?? "")
                textHeightReply = detectTextHeihgt(text: text, numberChar: text.count + 1)
            }else{
                let countCharacter = AuthService.userData?.subscribeData?.package?.plan?.charactersPostCount ?? "300"
                textHeightReply = detectTextHeihgt(text: (model.text ?? ""), numberChar: Int(countCharacter) ?? 0)
            }
            
            textHeightPost =  detectTextHeihgt(text: model.postable?.text ?? "", numberChar: 50)
            let totalReplyMedia = replyVideoCount + replyImagesCount
            height += (textHeightPost + textHeightReply)
            height += totalPostMedia > 0 ? 120 : 0
            height += totalReplyMedia > 0 ? 130 : 0
            return (height)
            
        case .shareLocation:
            height = 165
            let countFriends = model.postable?.mentions?.count ?? 0
            let countMedia = (model.videos?.count ?? 0 ) + (model.images?.count ?? 0)
            let text = (model.text ?? "")
            let textHeight = detectTextHeihgt(text: text , numberChar: text.count + 1)
            
            height += textHeight
            height += countFriends > 0 ? 60 : 0 // 170
            height += countMedia > 0 ? 120 : 0 //10
            return height
        case .shareWatch:
            height = 190
            let text = (model.text ?? "")
            let textHeight = detectTextHeihgt(text: text , numberChar: text.count + 1)
            height += textHeight
            let countMedia = (model.videos?.count ?? 0 ) + (model.images?.count ?? 0)
            height += countMedia > 0 ? 120 : 0
            return height
        case .sponsor:
            return 190
        case .secretMessage:
            height = 120 //175
            var textHeightReply: CGFloat = 0
            var textHeightPost: CGFloat = 0
            
            if isFullPost {
                let text = (model.text ?? "")
                textHeightReply = detectTextHeihgt(text: text, numberChar: text.count + 1)
            }else{
                let countCharacter = AuthService.userData?.subscribeData?.package?.plan?.charactersPostCount ?? "300"
                textHeightReply = detectTextHeihgt(text: (model.text ?? ""), numberChar: Int(countCharacter) ?? 0)
            }
            
            let textPost =  model.postable?.message ?? ""
            textHeightPost =  detectTextHeihgt(text: textPost, numberChar: textPost.count + 1)

            height += (textHeightPost + textHeightReply)
            height += totalPostMedia > 0 ? 120 : 0

            return (height)
        }
    }
    private func detectTextHeihgt(text: String, numberChar: Int) -> CGFloat {
        var height: CGFloat = 0
        var str = ""
        if text.count > numberChar {
            str = text.subString(index: numberChar)
            height += str.height(constraintedWidth:  CGFloat(viewWidth), font: .CairoRegular(of: 13))
            height = height == 24.5 ? 15 : height
            height += 10
        }else {
            height = text.height(constraintedWidth:  CGFloat(viewWidth), font: .CairoRegular(of: 13))
            height = height == 24.5 ? 15 : height
        }
        return height
    }
    
    func getPostable(post: HomeModel) -> HomeModel {
        let posTabel = post.postable
        let model = HomeModel(id: posTabel?.id, postType: posTabel?.postType, activityType: posTabel?.activityType, text: posTabel?.text, createdAt: posTabel?.createdAt, createdAgo: posTabel?.createdAgo, isLike: posTabel?.isLike, likeType: posTabel?.likeType, isFav: posTabel?.isFav, location: posTabel?.location, watching: posTabel?.watching, images: posTabel?.images, videos: posTabel?.videos, user: posTabel?.user, postableType: nil, postable: nil, mentions: posTabel?.mentions, screenShots: posTabel?.screenShots, commentsCount: posTabel?.commentsCount, type: nil, file: nil, thumbnail: nil, sponsor: nil, desc: nil, url: nil, likesCount: posTabel?.likesCount, isShowFullPost: false)
        return model
    }
    
    func getPostType(post: inout HomeModel, type: String, isFullPost: Bool) ->  (postId: Int, postType: PostEnum, post: HomeModel, height: CGFloat) {
        print(type)
        let height = getCellHeight(model:post, activityTypeShare: post.postable?.activityType, type: type,isFullPost: isFullPost )
        
        let typeCell = getCellType(postType: post.postType ?? "", activityType: post.activityType ?? "", activityTypeShare: post.postable?.activityType, type:  type, postableType: post.postableType ?? "")
        
        let data = (postId: post.id ?? 0, postType: typeCell, post: post, height: height)
        return data
    }
    
    func getPostShare(post: inout HomeModel, type: String) -> (postId: Int, postType: PostEnum, post: HomeModel, height: CGFloat) {
        var _post: HomeModel
        
        if let _ = post.postable {
            _post = getPostable(post: post)
        }else {
            _post = post
        }
        return getPostType(post: &_post, type: type, isFullPost: false)
    }
}
