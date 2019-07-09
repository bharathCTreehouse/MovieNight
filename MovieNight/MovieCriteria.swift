//
//  MovieCriteria.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class MovieCriteria {
    
    var genres: [Genre]
    var actors: [Actor]?
    var certification: Certification?
    
    
    init(withGenres genres: [Genre], actors: [Actor]?, certification: Certification?) {
        self.genres = genres
        self.actors = actors
        self.certification = certification
    }
    
    
    func addActors(_ actorsToBeAdded: [Actor]) {
        if actors == nil {
            actors = []
        }
        actors!.append(contentsOf: actorsToBeAdded)
    }
    
}
