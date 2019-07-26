//
//  Movie.swift
//  MovieNight
//
//  Created by Bharath on 26/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct Movie: Decodable {
    
    let id: Int
    let voteCount: Int
    let video: Bool
    let voteAverage: Float
    let title: String
    let popularity: Float
    let posterPath: String?
    let originalLanguage: String
    let originalTitle: String
    let backdropPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    
}
