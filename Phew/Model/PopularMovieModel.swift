//
//  PopularMovieModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/21/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation

struct PopularMovieModel: Codable {
    let status, message: String?
    let data: [MovieModel]?
}

// MARK: - Datum
struct MovieModel: Codable {
    let id: Int?
    let movieID, movieData: String?
    let movieDetail: MoviFilm?
    let counter: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case movieID = "movie_id"
        case movieData = "movie_data"
        case movieDetail = "movie_detail"
        case counter
    }
}

