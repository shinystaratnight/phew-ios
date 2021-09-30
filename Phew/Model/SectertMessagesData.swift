//
//  SectertMessagesData.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/25/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation

struct SectertMessagesData: BaseCodable {
    var status: String?
    
    var message: String?
    
    
    let data: [SectertMessages]?
}

// MARK: - Datum
struct SectertMessages: Codable {
    let id: Int?
    let message, createdAt, agoTime: String?

    enum CodingKeys: String, CodingKey {
        case id, message
        case createdAt = "created_at"
        case agoTime = "ago_time"
    }
}
