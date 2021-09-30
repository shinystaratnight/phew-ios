//
//  CountryFindaly.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/24/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation
struct CountreyFindlyData: BaseCodable {
    var status: String?
    
    var message: String?
    
    
    let data: [CountreyFindly]?
}

// MARK: - Datum
struct CountreyFindly: Codable {
    let id: Int?
    let name, shortName: String?
    let flag: String?
    let showPhonecode, phonecode, continent: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
        case flag
        case showPhonecode = "show_phonecode"
        case phonecode, continent
    }
}
