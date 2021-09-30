//
//  UserDataModel.swift
//  BaseProject
//
//  Created by Youssef on 11/24/19.
//  Copyright © 2019 Youssef. All rights reserved.
//

import Foundation
struct UserData: Codable {
    let id: Int?
    let username, fullname, mobile, email: String?
    let gender, dateOfBirth: JSONNull?
    let profileImage: String?
    let profileImages: [ProfileImage]?
    let cover: String?
    let isVerified, isFollow: Bool?
    let followerCount, followingCount: Int?
    let isFriend, isFriendRequest: Bool?
    let senderFriendRequest: JSONNull?
    let friendsCount, postsCount: Int?
    let isSubscribed: Bool?
    let subscribeData: SubscribeData?
    let userSettings: UserSettings?
    let token: Token?
    let city: City?
    let nationality, lat, lng: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, username, fullname, mobile, email, gender
        case dateOfBirth = "date_of_birth"
        case profileImage = "profile_image"
        case profileImages = "profile_images"
        case cover
        case isVerified = "is_verified"
        case isFollow = "is_follow"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case isFriend = "is_friend"
        case isFriendRequest = "is_friend_request"
        case senderFriendRequest = "sender_friend_request"
        case friendsCount = "friends_count"
        case postsCount = "posts_count"
        case isSubscribed = "is_subscribed"
        case subscribeData = "subscribe_data"
        case userSettings = "user_settings"
        case token, city, nationality, lat, lng
    }
}

// MARK: - City
struct City: Codable {
    let id, countryID: Int?
    let countryName: String?
    let lat, lng: JSONNull?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case countryName = "country_name"
        case lat, lng, name
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let id: Int?
    let image: String?
}

//// MARK: - SubscribeData
//struct SubscribeData: Codable {
//    let id: Int?
//    let package: Package?
//    let packageType, subscriptionStartDate, subscriptionEndDate: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, package
//        case packageType = "package_type"
//        case subscriptionStartDate = "subscription_start_date"
//        case subscriptionEndDate = "subscription_end_date"
//    }
//}

// MARK: - Package
//struct Package: Codable {
//    let id: Int?
//    let packageType: String?
//    let price: Int?
//    let period, periodType: String?
//    let plan: Plan?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case packageType = "package_type"
//        case price, period
//        case periodType = "period_type"
//        case plan
//    }
//}

// MARK: - Plan
//struct Plan: Codable {
//    let charactersPostCount, profileImagesCount, friendsCount, periodToPinPostOnFindlyBySeconds: String?
//    let minimumPeriodForClearingInactiveAccountsByDays: String?
//
//    enum CodingKeys: String, CodingKey {
//        case charactersPostCount = "characters_post_count"
//        case profileImagesCount = "profile_images_count"
//        case friendsCount = "friends_count"
//        case periodToPinPostOnFindlyBySeconds = "period_to_pin_post_on_findly_by_seconds"
//        case minimumPeriodForClearingInactiveAccountsByDays = "minimum_period_for_clearing_inactive_accounts_by_days"
//    }
//}

// MARK: - Token
struct Token: Codable {
    let tokenType, accessToken: String?

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
    }
}

// MARK: - UserSettings
//struct UserSettings: Codable {
//    let id, allNotices, notificationToNewFollowers, notificationToMention: Int?
//    let deleteInactiveFollowersAndFriends: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case allNotices = "all_notices"
//        case notificationToNewFollowers = "notification_to_new_followers"
//        case notificationToMention = "notification_to_mention"
//        case deleteInactiveFollowersAndFriends = "delete_inactive_followers_and_friends"
//    }
//}

// MARK: - DataClass
//struct UserData: Codable {
//    let dateOfBirth: String?
//    let profileImage: String?
//    let id: Int?
//    let mobile, gender, username: String?
//    let userSetting: UserSetting?
//    let hasStore: Int?
//    let nationality: Nationality?
//    let location: Location?
//    let city: City?
//    let lastName, fullname, email: String?
//    var token: Token?
//    let firstName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case dateOfBirth = "date_of_birth"
//        case profileImage = "profile_image"
//        case id, mobile, gender, username
//        case userSetting = "user_settings"
//        case hasStore = "has_store"
//        case nationality, location, city
//        case lastName = "last_name"
//        case fullname, email, token
//        case firstName = "first_name"
//    }
//}
//struct UserSetting: Codable {
//    let id, allNotices, notificationToNewFollowers, notificationToMention: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case allNotices = "all_notices"
//        case notificationToNewFollowers = "notification_to_new_followers"
//        case notificationToMention = "notification_to_mention"
//    }
//}
//
//// MARK: - UserSetting
//
//
//// MARK: - City
//struct City: Codable {
//    let name: String?
//    let countryID, id: Int
//    let lat, lng: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case countryID = "country_id"
//        case id, lat, lng
//    }
//}
//
//// MARK: - Location
//struct Location: Codable {
//    let lat, lng: Double?
//}
//
//// MARK: - Nationality
//struct Nationality: Codable {
//    let id: Int?
//    let name: String?
//}
//
//// MARK: - Token
//struct Token: Codable {
//    var accessToken, tokenType: String?
//
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//        case tokenType = "token_type"
//    }
//}

import Foundation
//: # NestedKey
///
/// Use this to annotate the properties that require a depth traversal during decoding.
/// The corresponding `CodingKey` for this property must be a `NestableCodingKey`

// --> Example
// @NestedKey
// case token = "token/access_token"


@propertyWrapper
struct NestedKey<T: Decodable>: Decodable {
    
    var wrappedValue: T
    
    struct AnyCodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?
        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    
    init(from decoder: Decoder) throws {
        let key = decoder.codingPath.last!
        guard let nestedKey = key as? NestableCodingKey else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Key \(key) is not a NestableCodingKey"))
        }
        let nextKeys = nestedKey.path.dropFirst()
        // key descent
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        let lastLeaf = try nextKeys.indices.dropLast().reduce(container) { (nestedContainer, keyIdx) in
            do {
                return try nestedContainer.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(stringValue: nextKeys[keyIdx]))
            } catch DecodingError.keyNotFound(let key, let ctx) {
                try NestedKey.keyNotFound(key: key, ctx: ctx, container: container, nextKeys: nextKeys[..<keyIdx])
            }
        }
        // key leaf
        do {
            self.wrappedValue = try lastLeaf.decode(T.self, forKey: AnyCodingKey(stringValue: nextKeys.last!))
        } catch DecodingError.keyNotFound(let key, let ctx) {
            try NestedKey.keyNotFound(key: key, ctx: ctx, container: container, nextKeys: nextKeys.dropLast())
        }
    }
    private static func keyNotFound<C: Collection>(
        key: CodingKey, ctx: DecodingError.Context,
        container: KeyedDecodingContainer<AnyCodingKey>, nextKeys: C) throws -> Never
        where C.Element == String {
        throw DecodingError.keyNotFound(key, DecodingError.Context(
            codingPath: container.codingPath + nextKeys.map(AnyCodingKey.init(stringValue:)),
            debugDescription: "NestedKey: No value associated with key \"\(key.stringValue)\"",
            underlyingError: ctx.underlyingError
        ))
    }
}
//: # NestableCodingKey
/// Use this instead of `CodingKey` to annotate your `enum CodingKeys: String, NestableCodingKey`.
/// Use a `/` to separate the components of the path to nested keys
protocol NestableCodingKey: CodingKey {
    var path: [String] { get }
}

extension NestableCodingKey where Self: RawRepresentable, Self.RawValue == String {
    init?(stringValue: String) {
        self.init(rawValue: stringValue)
    }
    
    var stringValue: String {
        path.first!
    }
    
    init?(intValue: Int) {
        fatalError()
    }
    
    var intValue: Int? { nil }
    
    var path: [String] {
        self.rawValue.components(separatedBy: "/")
    }
}
