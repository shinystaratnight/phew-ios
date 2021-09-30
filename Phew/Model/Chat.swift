//
//  Chat.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/27/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation


struct ChatData: Codable {
    let status, message: String?
    let ChatModel: [ChatModel]?
}

// MARK: - Datum
struct ChatModel: Codable {
    let id, conversationID: Int?
    let messageType: String?
    let message: String?
    var messagePosition: String?
    let senderData: SenderData?
    let createdAt, agoTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case conversationID = "conversation_id"
        case messageType = "message_type"
        case message
        case messagePosition = "message_position"
        case senderData = "sender_data"
        case createdAt = "created_at"
        case agoTime = "ago_time"
    }
}

// MARK: - SenderData
struct SenderData: Codable {
    let id: Int?
    let username, fullname: String?
    let profileImage: String?
    let isFollow, isFriend: Bool?
    let city: City?

    enum CodingKeys: String, CodingKey {
        case id, username, fullname
        case profileImage = "profile_image"
        case isFollow = "is_follow"
        case isFriend = "is_friend"
        case city
    }
}
