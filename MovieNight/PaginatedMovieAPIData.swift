//
//  PaginatedMovieAPIData.swift
//  MovieNight
//
//  Created by Bharath on 06/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class PaginatedMovieAPIData: PaginatedAPIData {
    
    var genreQueryConfig: CollectionQueryItemConfigurer?
    var actorQueryConfig: CollectionQueryItemConfigurer?
    var certification: Certification?
    
    
    init(withGenreConfig genre: CollectionQueryItemConfigurer?, actorConfig actor: CollectionQueryItemConfigurer?, certification: Certification?, pageToFetch page: Int, maxPageLimit limit: Int? ) {
        
        genreQueryConfig = genre
        actorQueryConfig = actor
        self.certification = certification
        super.init(withPageToFetch: page, maxPageLimit: limit)
    }
}
