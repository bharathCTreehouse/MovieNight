//
//  GenreResultList.swift
//  MovieNight
//
//  Created by Bharath on 29/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct GenreResultList: Decodable {
    
    let allGenres: [Genre]
    
    
    enum OuterCodingKeys: String, CodingKey {
        case genres
    }
    
    
    init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: OuterCodingKeys.self)
        allGenres = try container.decode([Genre].self, forKey: .genres)
    }

}
