//
//  PackageModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/21/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation
class PackageModel: Codable {
    let id: Int?
    let packageType, period, periodType: String?
    let plan: Plan?
    var isSelected: Bool? = false
  

    enum CodingKeys: String, CodingKey {
        case id
        case packageType = "package_type"
        case period
        case periodType = "period_type"
        case plan
    }
}

// MARK: - Plan
//struct Plan: Codable {
//    let charactersPostCount, profileImagesCount, friendsCount, periodToPinPostOnFindlyBySeconds: String?
//    let minimumPeriodForClearingInactiveAccountsByDays: String?
//
//    enum CodingKeys: String, CodingKey {
//        case charactersPostCount = "characters_post_count"
//        case profileImagesCount = "profile_images_count"
//        case friendsCount = "friends_count"
//        case periodToPinPostOnFindlyBySeconds = "period_to_pin_post_on_findly_by_seconds"
//        case minimumPeriodForClearingInactiveAccountsByDays = "minimum_period_for_clearing_inactive_accounts_by_days"
//    }
//}
