//
//  MovieListViewModel.swift
//  MovieNight
//
//  Created by Bharath on 26/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class MovieListViewModel {
    
    private(set) var movie: Movie
    private(set) var posterImage: UIImage? = nil

    init(withMovie movie: Movie) {
        self.movie = movie
    }
    
    func update(posterImage image: UIImage?) {
        posterImage = image
    }
    
}


extension MovieListViewModel: Hashable {
    
    
    static func == (lhs: MovieListViewModel, rhs: MovieListViewModel) -> Bool {
        return lhs.movie.id == rhs.movie.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(movie.id)
    }
}



extension MovieListViewModel: TextWithSubtTitleDisplayable {
    
    var textAttribute: TextWithAttribute {
        return TextWithAttribute(text: movie.title, font: UIFont.systemFont(ofSize: 18.0), color: UIColor.black)
    }
    
    var subTitleTextAttribute: TextWithAttribute {
        
        if movie.title != movie.originalTitle {
            return TextWithAttribute(text: movie.originalTitle, font: UIFont.systemFont(ofSize: 17.0), color: UIColor.darkGray)
        }
        else {
            return TextWithAttribute(text: "", font: UIFont.systemFont(ofSize: 17.0), color: UIColor.darkGray)
        }
    }
    
    var contentImage: UIImage? {
        return posterImage
    }
    
    
    var moreInfoButtonAttribute: ButtonAttribute? {
        return ButtonAttribute(type: .infoDark, title: nil, titleColorForNormalState: nil)
    }

    
    var ID: String {
        return String(movie.id)
    }
}
