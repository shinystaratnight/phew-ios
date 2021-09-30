//
//  FriendsDataModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/27/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
struct FriendsDataModel: BaseCodable {
    var status: String?
    
    var message: String?
    
   
    let data: [FriendsModel]?
}

// MARK: - Datum
struct FriendsModel: Codable {
    let user: User?
    let date: String?
}



