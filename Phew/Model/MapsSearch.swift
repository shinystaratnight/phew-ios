//
//  SearchPlaces.swift
//  AmnuhClient
//
//  Created by Ahmed Elesawy on 3/15/20.
//  Copyright © 2020 Ahmed Elesawy. All rights reserved.
//

import Foundation



// MARK: - ChatDetailsData
struct MapsSearchModel: BaseCodable {
    let results: [MapsSearchData]?
    var status: String? = "ok"
    var message: String?
    
}

// MARK: - Candidate
struct MapsSearchData: Codable {
    let formattedAddress: String?
    let geometry: Geometry?
    let icon: String?
    let id, name: String?
    //    let photos: [JSONAny]?
    let placeID, reference: String?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case geometry, icon, id, name
        case placeID = "place_id"
        case reference, types
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location?
    let viewport: Viewport?
}

//// MARK: - Location
struct Location: Codable {
    let lat, lng: Double?
}

// MARK: - Viewport
struct Viewport: Codable {
    let northeast, southwest: Location?
}


