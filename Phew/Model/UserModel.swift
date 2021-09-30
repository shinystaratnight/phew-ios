//
//  User.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

// MARK: - DataClass
//struct UserDataModel: Codable {
//    let status, message: String?
//    let data: DataClass?
//}

// MARK: - DataClass
class User: Codable {
    
    let id: Int?
    let username, fullname, mobile, email: String?
    let gender, dateOfBirth: JSONNull?
    let profileImage: String?
    var isVerified, isFollow: Bool?
    let followerCount, followingCount, friendsCount, postsCount: Int?
    let isSubscribed: Bool?
    let subscribeData: SubscribeData?
    let userSettings: UserSettings?
    let token: Token?
    let city: City?
    let nationality, lat, lng: String?
    var senderFriendRequest: String?
    var isSelected: Bool = false
    let cover: String?
    var isFriendRequest: Bool?
    var isFriend: Bool?
    var profileImages: [ImageProfile]?
    
    init(id: Int?, username: String?, fullname: String?, mobile: String?, email: String?, gender: JSONNull?, dateOfBirth: JSONNull?, profileImage: String?, isVerified: Bool?, isFollow: Bool?, followerCount: Int?, followingCount: Int?, friendsCount: Int?, postsCount: Int?, isSubscribed: Bool?, subscribeData: SubscribeData?, userSettings: UserSettings?, token: Token?, city: City?, nationality: String?, lat: String?, lng: String?, isSelected: Bool = false, cover: String?, senderFriendRequest: String?, isFriendRequest: Bool?, isFriend: Bool?, profileImages: [ImageProfile]?) {
        self.id = id
        self.username = username
        self.fullname = fullname
        self.mobile = mobile
        self.email = email
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.profileImage = profileImage
        self.isVerified = isVerified
        self.isFollow = isFollow
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.friendsCount = friendsCount
        self.postsCount = postsCount
        self.isSubscribed = isSubscribed
        self.subscribeData = subscribeData
        self.userSettings = userSettings
        self.token = token
        self.city = city
        self.nationality = nationality
        self.lat = lat
        self.lng = lng
        self.isSelected = isSelected
        self.cover = cover
        self.senderFriendRequest = senderFriendRequest
        self.isFriendRequest = isFriendRequest
        self.isFriend = isFriend
        self.profileImages = profileImages
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id, username, fullname, mobile, email, gender
        case dateOfBirth = "date_of_birth"
        case profileImage = "profile_image"
        case isVerified = "is_verified"
        case isFollow = "is_follow"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case friendsCount = "friends_count"
        case postsCount = "posts_count"
        case isSubscribed = "is_subscribed"
        case subscribeData = "subscribe_data"
        case userSettings = "user_settings"
        case token, city, nationality, lat, lng
        case cover
        case senderFriendRequest = "sender_friend_request"
        case isFriendRequest = "is_friend_request"
        case  isFriend = "is_friend"
        case profileImages  = "profile_images"
    }
}
struct ImageProfile: Codable {
    let id: Int?
    let image: String?
}
// MARK: - SubscribeData
struct SubscribeData: Codable {
    let id: Int?
    let package: Package?
    let packageType, subscriptionStartDate, subscriptionEndDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, package
        case packageType = "package_type"
        case subscriptionStartDate = "subscription_start_date"
        case subscriptionEndDate = "subscription_end_date"
    }
}

// MARK: - Package
struct Package: Codable {
    let id: Int?
    let packageType, period, periodType: String?
    let plan: Plan?
    
    enum CodingKeys: String, CodingKey {
        case id
        case packageType = "package_type"
        case period
        case periodType = "period_type"
        case plan
    }
}

// MARK: - Plan
struct Plan: Codable {
    let charactersPostCount, profileImagesCount, friendsCount, periodToPinPostOnFindlyBySeconds: String?
    let minimumPeriodForClearingInactiveAccountsByDays: String?
    
    enum CodingKeys: String, CodingKey {
       
        case charactersPostCount = "characters_post_count"
        case profileImagesCount = "profile_images_count"
        case friendsCount = "friends_count"
        case periodToPinPostOnFindlyBySeconds = "period_to_pin_post_on_findly_by_seconds"
        case minimumPeriodForClearingInactiveAccountsByDays = "minimum_period_for_clearing_inactive_accounts_by_days"
    }
}


// MARK: - UserSettings
struct UserSettings: Codable {
    let id, allNotices, notificationToNewFollowers, notificationToMention: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case allNotices = "all_notices"
        case notificationToNewFollowers = "notification_to_new_followers"
        case notificationToMention = "notification_to_mention"
    }
}

