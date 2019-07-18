//
//  MovieCriteria.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class MovieCriteria {
    
    var genres: [String]
    private(set) var actors: [String]?
    var certification: Certification?
    
    
    init(withGenres genres: [String], actors: [String]?, certification: Certification?) {
        self.genres = genres
        self.actors = actors
        self.certification = certification
    }
    
    
    func addActors(withIDs_ actorsToBeAdded: [String]) {
        if actors == nil {
            actors = []
        }
        actors!.append(contentsOf: actorsToBeAdded)
    }
    
    func removeAllActors() {
        actors?.removeAll()
    }
    
    
    
    func addGenres(withIDs_ genresToBeAdded: [String]) {
        genres.append(contentsOf: genresToBeAdded)
    }
    
    func removeAllGenres() {
        genres.removeAll()
    }
    
    
    
    deinit {
        actors = nil
        certification = nil
    }
    
}
