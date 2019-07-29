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
    
    let movie: Movie
    var posterImage: UIImage? = nil

    init(withMovie movie: Movie) {
        self.movie = movie
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
        return TextWithAttribute(text: movie.title, font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize), color: UIColor.black)
    }
    
    var subTitleTextAttribute: TextWithAttribute {
         return TextWithAttribute(text: movie.originalTitle, font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize), color: UIColor.darkGray)
    }
    
    var contentImage: UIImage? {
        return posterImage
    }
    
    var ID: String {
        return String(movie.id)
    }
}
