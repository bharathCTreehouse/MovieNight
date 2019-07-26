//
//  MovieNightViewController.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class MovieNightViewController: UIViewController {
    
    var movieCriteria: MovieCriteria
    
    
    init(withMovieCriteria criteria: MovieCriteria) {
        movieCriteria = criteria
        super.init(nibName: nil, bundle:nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        movieCriteria = MovieCriteria(withGenres: [], actors: nil, certifications: nil)
        super.init(coder: aDecoder)
    }
}
