//
//  SocialInfo.swift
//  Phew
//
//  Created by Mohamed Akl on 9/10/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

// MARK: - SocilaInfoModel
struct SocilaInfoModel: BaseCodable {
    var status, message: String?
    let data: SocilaInfoData?
}

// MARK: - SocilaInfoData
struct SocilaInfoData: Codable {
    let email, mobile: String?
    let facebookURL, twitterURL, youtubeURL, instagramURL: String?
    let whatsappPhone: String?

    enum CodingKeys: String, CodingKey {
        case email, mobile
        case facebookURL = "facebook_url"
        case twitterURL = "twitter_url"
        case youtubeURL = "youtube_url"
        case instagramURL = "instagram_url"
        case whatsappPhone = "whatsapp_phone"
    }
}
