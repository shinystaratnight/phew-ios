//
//  MovieViewModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/21/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation

struct MovieViewModel: Codable {
    let id: Int?
    let title: String?
    let logoImage: String?
    let voteCount: Int?
    let releaseDate: String?
}
