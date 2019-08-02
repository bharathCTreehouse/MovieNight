//
//  MovieDetailViewModel.swift
//  MovieNight
//
//  Created by Bharath on 31/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class MovieDetailViewModel {
    
    let movie: Movie
    private(set) var backdropImage: UIImage?
    
    init(withMovie movie: Movie) {
        self.movie = movie
    }
    
    func update(withBackdropImage image: UIImage?) {
        backdropImage = image
    }
    
    deinit {
        backdropImage = nil
    }
}



extension MovieDetailViewModel {
    
    var movieNameAttribute: TextWithAttribute {
        return TextWithAttribute(text: movie.originalTitle, font: UIFont.boldSystemFont(ofSize: 20.0), color: UIColor.black)
    }
    
    var overviewAttribute: TextWithAttribute {
        return TextWithAttribute(text: movie.overview, font: UIFont.systemFont(ofSize: 18.0), color: UIColor.black)
    }
    
    var averageRatingAttribute: TextWithAttribute {
        return TextWithAttribute(text: String(movie.voteAverage)+"/10", font: UIFont.systemFont(ofSize: 17.0), color: UIColor.black)
    }
    
    var ratingCountAttribute: TextWithAttribute {
        return TextWithAttribute(text: String(movie.voteCount), font: UIFont.systemFont(ofSize: 17.0), color: UIColor.black)
    }
    
    var dateOfReleaseAttribute: TextWithAttribute {
        return TextWithAttribute(text: movie.releaseDate, font: UIFont.systemFont(ofSize: 17.0), color: UIColor.black)
    }
    
}
