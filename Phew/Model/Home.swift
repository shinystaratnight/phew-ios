//
//  Home.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/9/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//
// MARK: - HomeData


struct PostModel:BaseCodable {
    var status: String?
    var message: String?
    let data: HomeModel?
}

struct HomeData: BaseCodable {
    let data: [HomeModelType]?
    var status: String?
    var message: String?
    let meta: Meta?
}

// MARK: - Datum
struct HomeModelType: Codable {
    let type: String?
    var data: HomeModel?
}

// MARK: - DataClass
struct HomeModel: Codable {
    let id: Int?
    let postType: String?
    let activityType: String?
    let text, createdAt: String?
    let createdAgo: String?
    var isLike: Bool?
    var likeType: String?
    var isFav: Bool?
    let location, watching: Image?
    let images, videos: [Image]?
    let user: User?
    let postableType: String?
    let postable: Postable?
    let mentions, screenShots: [User]?
    let commentsCount: Int?
    let type: String?
    let file: String?
    let thumbnail: String?
    let sponsor: Sponsor?
    let desc: String?
    let url: String?
    var likesCount: Int?
    var isShowFullPost: Bool?
    var retweeted: Bool?

    enum CodingKeys: String, CodingKey {
        case retweeted
        case isShowFullPost
        case id
        case postType = "post_type"
        case activityType = "activity_type"
        case text
        case createdAt = "created_at"
        case createdAgo = "created_ago"
        case isLike = "is_like"
        case likeType = "like_type"
        case isFav = "is_fav"
        case location, watching, images, videos, user, postable, mentions
        case screenShots = "screen_shots"
        case commentsCount = "comments_count"
        case type, file, sponsor, desc, url
        case thumbnail
        case likesCount = "likes_count"
        case postableType = "postable_type"
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let data: String?
    let coverName: String?

    enum CodingKeys: String, CodingKey {
        case id, data
        case coverName = "cover_name"
    }
}
// MARK: - Postable
struct Postable: Codable {
    let id: Int?
    let postType: String?
    let activityType: String?
    let text, createdAt: String?
    let createdAgo: String?
    var isLike: Bool?
    var likeType: String?
    let isFav: Bool?
    let location, watching: Image?
    let images, videos: [Image]?
    let user: User?
    let mentions: [User]?
    let screenShots: [User]?
    let commentsCount: Int?
    let likesCount: Int?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case id
        case postType = "post_type"
        case activityType = "activity_type"
        case text
        case createdAt = "created_at"
        case createdAgo = "created_ago"
        case isLike = "is_like"
        case likeType = "like_type"
        case isFav = "is_fav"
        case location, watching, images, videos, user, mentions
        case screenShots = "screen_shots"
        case commentsCount = "comments_count"
        case likesCount = "likes_count"
        case message
    }
}

// MARK: - Sponsor
struct Sponsor: Codable {
    let id: Int?
    let name: String?
    let logo: String?
}

// MARK: - Meta
struct Meta: Codable {
    let currentPage, from, lastPage: Int?
    let path: String?
    let perPage, to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case path
        case perPage = "per_page"
        case to, total
    }
}
