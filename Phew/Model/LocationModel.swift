//
//  LocationModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/11/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

struct LocationModel: Codable {
    let lat, lng: Double?
    let address: String?
}

