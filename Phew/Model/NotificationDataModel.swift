//
//  NotificationDataModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/22/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation

struct NotificationDataModel: BaseCodable {
    var status: String?
    
    var message: String?
    
    let data: [NotificationModel]?
}

// MARK: - Datum
struct NotificationModel: Codable {
    let id, createdTime, createdAt, key: String?
    let keyType: String?
    let keyID: Int?
    let title: String?
    let body: String?
    let senderData: SenderData?

    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case createdAt = "created_at"
        case key
        case keyType = "key_type"
        case keyID = "key_id"
        case title, body
        case senderData = "sender_data"
    }
}
