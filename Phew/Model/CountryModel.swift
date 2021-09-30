//
//  CountryModel.swift
//  Phew
//
//  Created by Mohamed Akl on 9/7/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

// MARK: - CountryModel
struct CountryModel: Codable {
    let showPhonecode, name, phonecode, shortName: String?
    let continent: String?
    let id: Int
    let flag: String?
    
    enum CodingKeys: String, CodingKey {
        case showPhonecode = "show_phonecode"
        case name, phonecode
        case shortName = "short_name"
        case continent, id, flag
    }
}

struct CityModel: Codable {
    let id, countryID: Int?
    let countryName: String?
    let lat, lng: Double?
    let name: String?
    let likeCount: Int?
    let likeType: String?
    let likeTypeCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case countryName = "country_name"
        case lat, lng, name
        case likeCount = "like_count"
        case likeType = "like_type"
        case likeTypeCount = "like_type_count"
    }
}
