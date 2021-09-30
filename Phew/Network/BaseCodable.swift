//
//  BaseCodable.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

protocol BaseCodable: Codable {
    var status: String? { get set }
    var message: String? { get set }
}

struct BaseModel: BaseCodable {
    var status: String?
//    var data: String?
    var message: String?
}

struct BaseModelWith<T: Codable>: BaseCodable {
    var status: String?
    var data: T?
    var message: String?
}

struct BaseModelData: BaseCodable {
    var status: String?
    var data: String?
    var message: String?
}
