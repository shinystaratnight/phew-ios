//
//  SettingModel.swift
//  Phew
//
//  Created by Mohamed Akl on 9/10/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

// MARK: - AboutAppModel
struct AboutAppModel: BaseCodable {
    var status, message: String?
    let data: AboutAppData?
}

// MARK: - AboutAppData
struct AboutAppData: Codable {
    let about: String?
}

// MARK: - TermsAppModel
struct TermsAppModel: BaseCodable {
    var status, message: String?
    let data: TermsAppData?
}

// MARK: - TermsAppData
struct TermsAppData: Codable {
    let conditionsTerms: String?

    enum CodingKeys: String, CodingKey {
        case conditionsTerms = "conditions_terms"
    }
}
