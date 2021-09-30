//
//  ConversationModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/1/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation

struct ConversationModel: Codable {
    let id: Int?
    let messageType, lastMessage: String?
    let senderData, receiverData, otherUserData: User?
    let createdAt, agoTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case messageType = "message_type"
        case lastMessage = "last_message"
        case senderData = "sender_data"
        case receiverData = "receiver_data"
        case otherUserData = "other_user_data"
        case createdAt = "created_at"
        case agoTime = "ago_time"
    }
}
